module Filter

using DSP, FFTW
using Match

export decode, filter_signal

get_symbol(f1, f2) = @match (f1, f2) begin

	(941, 1336) => "0"
	(697, 1209) => "1"
	(697, 1336) => "2"
	(697, 1477) => "3"
	(770, 1209) => "4"
	(770, 1336) => "5"
	(770, 1477) => "6"
	(852, 1209) => "7"
	(852, 1336) => "8"
	(852, 1477) => "9"
	(941, 1209) => "*"
	(941, 1477) => "#"
	(697, 1633) => "A"
	(770, 1633) => "B"
	(852, 1633) => "C"
	(941, 1633) => "D"
	_ => ""
end

function get_filter(fs, width, fc)

	x_h = width .* (-0.05:(1/fs):0.05)

	h = sinc.(x_h)

	wc = ((2*pi)/fs) * fc

	h_bp = h .* cos.((0:(length(h) - 1)) .* wc)

	return h_bp
end

# Filter the signal for
# the given frecuency 'fc'
function filter_signal(s, fs; width, fc)

	# Create the filter
	bp = get_filter(fs, width, fc)

	# Filter the signal
	y = conv(s, bp)

	return y
end

function get_window(fs, f)
	
	N = Int(round((1/f) * fs)) * 3;

	win = tukey(N, 0.50)

	return win
end

function get_envolvent(win, e)

	# Envolvent
	y = conv(win, e)

	y = y[div(length(win), 2):end]

	# Normalize envolvent
	y = y .* (maximum(abs.(e))/maximum(abs.(y)))

	return y
end

function detect_pulses(y)

	# Threshold
	thres = ones(length(y)) .* (1.45)

	# Detect frequency pulses from the other things
	pulses = map(x -> Int(x), y .> thres)

	# Detect where the pulses
	# start and end
	differ = diff(pulses)

	# Indexes where the pulses start
	pulses_start = map(x -> x + 1, findall(x -> x == 1, differ))

	return pulses_start
end	

function analyze_pulses(lowy, highy, lowf, highf, fs)

	# Energies
	lowe = lowy .^ 2
	highe = highy .^ 2

	# Store max in energy to 
	# compare at the end
	maxe = (maximum(abs.(lowe)) + maximum(abs.(highe))) / 2

	# Normalize energies
	lowe = lowe ./ maximum(abs.(lowe))
	highe = highe ./ maximum(abs.(highe))

	# Sum of the energies
	e = lowe .+ highe

	win = get_window(fs, lowf)

	y = get_envolvent(win, e)

	pulses = detect_pulses(y)

	# Symbol mapping
	sym = get_symbol(lowf, highf)
	pulses = map(x -> (sym, x, maxe), pulses)

	return pulses
end

function analyze_energy(symbols)

	# Analize maximums of energy
	max_energies = map(x -> x[3], symbols)
	maxe = maximum(max_energies)

	# Normalize energy maximums
	symbols = map(x -> (x[1], x[2], x[3]/maxe), symbols)

	# Discard the elements that do not pass
	# the energy threshold of 20%
	symbols = filter(x -> x[3] > 0.20, symbols)

	# Sort by sample starting
	sort!(symbols, by = x -> x[2])

	symbols = map(x -> x[1], symbols)

	return symbols
end

function decode(s, fs)

	s = vec(s)
	
	# Combine low and high frequencies
	# and analiyze them to decode the symbols
	#
	# After this analysis, 'symbols' will
	# contain tuples in the following form:
	#
	# syms = [(3, 500), (2,1000), (3,400), (3,800), (7,1200)]
	#
	# and then it will be sorted by the second element
	# of the tuple, which is the sample where it begins that
	# pulse
	#
	# syms = [(3,400), (2,500), (3,800), (2,1000), (7,1200)]
	#
	# Finally a 'map' operation will remove the
	# samples startings,
	#
	# syms = [3, 2, 3, 2, 7]
	#
	
	symbols = []

	for lowf in [697, 770, 852, 941]

		lowy = filter_signal(s, fs, fc=lowf, width=40)
		
		for highf in [1209, 1336, 1477, 1633]
			
			highy = filter_signal(s, fs, fc=highf, width=50)
			
			syms = analyze_pulses(lowy, highy, lowf, highf, fs)
			
			append!(symbols, syms)
		end
	end

	symbols = analyze_energy(symbols)

	return symbols
end

end # module
