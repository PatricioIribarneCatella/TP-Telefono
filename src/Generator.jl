module Generator

using WAV
using Match

export generate_signal

# Maps digits with its corresponding
# output frecuencies
get_frecs(digit, x, silence_samples) = @match digit begin
	"0" => sen(x, 941) .+ sen(x, 1336)
	"1" => sen(x, 697) .+ sen(x, 1209)
	"2" => sen(x, 697) .+ sen(x, 1336)
	"3" => sen(x, 697) .+ sen(x, 1477)
	"4" => sen(x, 770) .+ sen(x, 1209)
	"5" => sen(x, 770) .+ sen(x, 1336)
	"6" => sen(x, 770) .+ sen(x, 1477)
	"7" => sen(x, 852) .+ sen(x, 1209)
	"8" => sen(x, 852) .+ sen(x, 1336)
	"9" => sen(x, 852) .+ sen(x, 1477)
	"*" => sen(x, 941) .+ sen(x, 1209)
	"#" => sen(x, 941) .+ sen(x, 1477)
	"A" => sen(x, 697) .+ sen(x, 1633)
	"B" => sen(x, 770) .+ sen(x, 1633)
	"C" => sen(x, 852) .+ sen(x, 1633)
	"D" => sen(x, 941) .+ sen(x, 1633)
	"_" => zeros(silence_samples)
end

function sen(x, frec)
	return sin.((2*pi*frec).*x)
end

# Generates a new dialing signal:
#
# - 'sequence': tones to be generated, it
# 		includes the silences
# 	example: 
# 		1) ["4", "_", "7", "_", "4", "_", "4"] (4_7_4_4)
# 		2) ["4", "_", "_", "7", "_", "4", "_", "_", "4"] (4__7_4__4)
# 		3) ["*", "_", "1", "_", "5", "_", "0", "#"] (*_1_5_0_#)
# - 'time': tones duration
# - 'sample_frec': sample frecuency
#
function generate_signal(sequence, time=0.070, sample_frec=8000, silence_time=0.070)

	res = []

	x = (0:(1/sample_frec):time)

	silence_samples = Integer(sample_frec * silence_time) + 1

	for digit in sequence
		y = get_frecs(digit, x, silence_samples)
		res = [res; y]
	end

	# Transform it in a 64 bit float 'Array'
	res = Array{Float64,1}(res)

	# Store it in a WAV file
	wavwrite(res, "tone.wav", Fs=sample_frec)

	return res
end

end # module
