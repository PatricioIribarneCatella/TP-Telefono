module Generator

using WAV
using Match

export generate_signal

# Maps digits with its corresponding
# output frecuencies
get_frecs(digit, x, time, sample_frec) = @match digit begin
	"0" => sen(x, 941, sample_frec) .+ sen(x, 1336, sample_frec)
	"1" => sen(x, 697, sample_frec) .+ sen(x, 1209, sample_frec)
	"2" => sen(x, 697, sample_frec) .+ sen(x, 1336, sample_frec)
	"3" => sen(x, 697, sample_frec) .+ sen(x, 1477, sample_frec)
	"4" => sen(x, 770, sample_frec) .+ sen(x, 1209, sample_frec)
	"5" => sen(x, 770, sample_frec) .+ sen(x, 1336, sample_frec)
	"6" => sen(x, 770, sample_frec) .+ sen(x, 1477, sample_frec)
	"7" => sen(x, 852, sample_frec) .+ sen(x, 1209, sample_frec)
	"8" => sen(x, 852, sample_frec) .+ sen(x, 1336, sample_frec)
	"9" => sen(x, 852, sample_frec) .+ sen(x, 1477, sample_frec)
	"*" => sen(x, 941, sample_frec) .+ sen(x, 1209, sample_frec)
	"#" => sen(x, 941, sample_frec) .+ sen(x, 1477, sample_frec)
	"A" => sen(x, 697, sample_frec) .+ sen(x, 1633, sample_frec)
	"B" => sen(x, 770, sample_frec) .+ sen(x, 1633, sample_frec)
	"C" => sen(x, 852, sample_frec) .+ sen(x, 1633, sample_frec)
	"D" => sen(x, 941, sample_frec) .+ sen(x, 1633, sample_frec)
	"s" => zeros(Integer(time*sample_frec) + 1)
end

function sen(x, frec, sample_frec)
	return sin.((2*pi*frec*(1/sample_frec)).*x)
end

# Generates a new dialing signal:
#
# - 'sequence': tones to be generated, it
# 		includes the silences
# 	example: 
# 		1) ["4", "s", "7", "s", "4", "s", "4"] (4_7_4_4)
# 		2) ["4", "s", "s", "7", "s", "4", "s", "s", "4"] (4__7_4__4)
# 		3) ["*", "s", "1", "s", "5", "s", "0", "#"] (*_1_5_0_#)
# - 'time': tones duration
# - 'sample_frec': sample frecuency
#
function generate_signal(sequence, time=0.070, sample_frec=8000)

	res = []

	x = [0:time*sample_frec;]

	for digit in sequence
		y = get_frecs(digit, x, time, sample_frec)
		res = [res; y]
	end

	# Transform it in a 64 bit float 'Array'
	res = Array{Float64,1}(res)

	# Store it a WAV file
	wavwrite(res, "tone.wav", Fs=sample_frec)

	return res
end

end # module
