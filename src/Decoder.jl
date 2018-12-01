module Decoder

using DSP, FFTW
using Match

export decode

# Returns two vectors containing
# the indexes where samples with
# information (aka: different from silences)
# start and end
#
function find_data_samples(x, window, get_threshold)

	if isempty(x)
		return [], []
	end

	# Normalize samples
	x = x ./ maximum(abs.(x))

	# Calculate the envolvent
	y = conv(window, x)

	# Keep the samples beginning in N/2
	# because the convolution shift it in that amount
	y1 = y[div(length(window), 2):end]

	# Threshold
	thres = ones(length(y1)) .* get_threshold(y1)

	# Detecting tones and silences
	pulses = map(x -> Int(x), y1 .> thres)

	# To detect where the
	# start and end of each pulse are
	differ = diff(pulses)

	# Indexes where the pulses start
	pulses_start = map(x -> x + 1, findall(x -> x == 1, differ))

	# Indexes where the pulses end
	pulses_end = findall(x -> x == -1, differ)
	
	return pulses_start, pulses_end
end

function get_time_window(fs)

	# The samples per period
	# The longest period is for the smallest freq
	# In this case: 697 Hz ~ 500 Hz
	samples_period = Int(0.005 * fs)

	# Window size is 3 periods
	N = samples_period * 3

	h = ones(N) ./ N

	return h
end

function get_pulse_window()

	N = 120
	h = tukey(N, 0.5) ./ (N/4)

	return h
end

function get_freq_window()

	N = 10
	h = tukey(N, 0.5) ./ (N/2)

	return h
end

function time_threshold(y)
	return 0.0125
end

function pulse_threshold(y)
	return 0.85 * maximum(y)
end

function freq_threshold(y)
	return 0.15 * maximum(y) 
end

# Given a frequency it matches to a
# (start, end) interval it returns
# the frequency that belongs to it
get_freq(f) = @match f begin
	600:733 => 697
	744:811 => 770
	812:896 => 852
	897:1020 => 941
	1100:1272 => 1209
	1273:1406 => 1336
	1407:1555 => 1477
	1556:1700 => 1633
	_ => 0
end

get_symbol(f1, f2) = @match (f1, f2) begin

	(941, 1336) || (1336, 941) => "0"
	(697, 1209) || (1209, 697) => "1"
	(697, 1336) || (1336, 697) => "2"
	(697, 1477) || (1477, 697) => "3"
	(770, 1209) || (1209, 770) => "4"
	(770, 1336) || (1336, 770) => "5"
	(770, 1477) || (1477, 770) => "6"
	(852, 1209) || (1209, 852) => "7"
	(852, 1336) || (1336, 852) => "8"
	(852, 1477) || (1477, 852) => "9"
	(941, 1209) || (1209, 941) => "*"
	(941, 1477) || (1477, 941) => "#"
	(697, 1633) || (1633, 697) => "A"
	(770, 1633) || (1633, 770) => "B"
	(852, 1633) || (1633, 852) => "C"
	(941, 1633) || (1633, 941) => "D"
	_ => ""
end

# Receives a list of tuples containing
# the start and end of the interval
# that corresponds to a given frequency
#
# Returns the symbol it belongs to
function decode_symbol(freqs)

	if isempty(freqs)
		return ""
	end

	freqs = map(f -> get_freq(div(f[1] + f[2], 2)), freqs)

	if length(freqs) < 2
		return ""
	end

	return get_symbol(freqs[1], freqs[2])
end

# Find frequency peaks and filter 
# only the ones that are not in the range
# of dialing tones
function analyze_freqs(X, fs)

	freqs = []
	
	if isempty(X)
		return freqs
	end
	
	starts, ends = find_data_samples(X,
					 get_freq_window(),
					 freq_threshold)

	samples_per_freq = Int(floor(fs/(2*length(X))))

	starts = starts .* samples_per_freq
	ends = ends .* samples_per_freq

	for i in range(1, length(starts))

		# Filter frequencies only in the
		# range of (500 Hz, 1700 Hz)
		if (500 <= starts[i] <= 1700 &&
			ends[i] <= 1800 &&
			1 <= ends[i] - starts[i] < 250)

			push!(freqs, (starts[i], ends[i]))
		end
	end

	return freqs
end

function analyze_pulse(pulse, fs)

	e = pulse .^ 2

	starts, ends = find_data_samples(e,
					 get_pulse_window(),
					 pulse_threshold)

	symbols = []

	for i in range(1, length(starts))
	
		# Because of the convolution with
		# the window, in some cases the 'ends'
		# indexes may be outside the range of
		# the pulse.
		if ends[i] > length(pulse)
			p = pulse[starts[i]:end]
		else
			p = pulse[starts[i]:ends[i]]
		end
		
		X = abs.(fft(p))
		X = X[1:div(end,2)]
		
		freqs = analyze_freqs(X, fs)
		sym = decode_symbol(freqs)

		append!(symbols, sym)
	end

	return symbols
end

function decode(s, fs)

	s = vec(s)

	e = s .^ 2
	
	symbols = []

	starts, ends = find_data_samples(e,
					 get_time_window(fs),
					 time_threshold)

	# Analyze all data chunks looking for
	# the "dialing" frequencies
	for i in range(1, length(starts))
		
		pulse = s[starts[i]:ends[i]]
		
		syms = analyze_pulse(pulse, fs)

		append!(symbols, syms)
	end

	return symbols
end

end # module
