using DSP, WAV, PyPlot

# Plot the samples
function plot_wave(s, fs)
	title("Modem Dialing - fs: $fs")
	x_axis = (0:(length(s) - 1))./fs
	plot(x_axis, s)
	xlabel("Time [s]")
end

function plot_spectrogram(s, fs)
	specgram()
end

# Start entry
function main(wav_file)

	# Read the WAV file
	s, fs = wavread(wav_file)

	plot_wave(s, fs)
	plot_spectrogram(s, fs)
end

main("modemDialing.wav")

