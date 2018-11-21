using WAV
using DSP
using Plots

function main(wav_path, win_size)
	
	s, fs = wavread(wav_path)

	s = vec(s)

	e = s .^ 2

	# The samples per period
	# The longest period is for the largest freq
	# In this case: 697 Hz ~ 500 Hz
	samples_period = Integer(0.005 * fs)

	# Window size is 3 periods
	N = samples_period * 3

	h = ones(N) ./ N

	y = conv(h, e)

	# Keep the samples beginning in N/2
	# because the convolution shift it in that amount
	y1 = y[div(N, 2):end]

	y_axis = (0:(length(e) + length(h) - 1)) ./ fs

	# Threshold
	thres = ones(length(y1)) .* 0.0125

	# Detecting tones and silences
	pulses = map(x -> Int(x), y1 .> thres)

	# To detect where the is the
	# start and end of each pulse
	differ = diff(pulses)

	one_idxs = map(x -> x + 1, findall(x -> x == 1, differ))
	minus_one_idxs = findall(x -> x == -1, differ)

	p = plot(y_axis, [e, y1, thres, pulses], title="Signal Energy Windowed (Win: $N)",
	     xlabel="Time [s]", lengend=false)

	savefig(p, "window_$N.png")
end

if PROGRAM_FILE == "SignalDecoding.jl"
	pyplot()
	main("dialing.wav", 1000)
end

