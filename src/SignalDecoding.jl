using WAV
using DSP
using Plots

function main(wav_path, win_size)
	
	s, fs = wavread(wav_path)

	e = s .^ 2

	N = win_size

	h = ones(N) ./ N

	y = conv(h, e)

	y_axis = (0:(length(e) + length(h) - 1)) ./ fs

	p = plot(y_axis, y, title="Signal Energy Windowed (Win: $N)",
	     xlabel="Time [s]", lengend=false)

	savefig(p, "window_$N.png")
end

if PROGRAM_FILE == "SignalDecoding.jl"
	pyplot()
	main("dialing.wav", 1000)
end

