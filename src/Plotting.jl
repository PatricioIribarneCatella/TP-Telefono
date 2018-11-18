module Plotting

using DSP, FFTW
using Plots

export set_plot, plot_frec, plot_wave, plot_spectrogram

# Sets backend renderer - PyPlot
function set_plot()
	pyplot()
end

# Plots wave in time
function plot_wave(s, fs)

	x_axis = (0:(length(s) - 1))./fs

	# Plot it
	p = plot(x_axis, s,
		 title="Modem Dialing - fs: $fs",
		 xlabel="Time [s]",
		 legend=false)
	
	# Save it in .png
	savefig(p, "wave.png")
end

# Plots wave in frecuency
function plot_frec(s, fs)

	# FFT of the input wave
	X = abs.(fft(s))

	# Shift it, so the samples are
	# shown as the real DFT is
	Xshift = fftshift(X)

	x_axis = (0:(1/length(Xshift)):1) .* (fs/2)
	
	# Plot it
	p = plot(x_axis, Xshift,
		 title="Modem Dialing Frecuency Domain",
		 xlabel="Freq [Hz]",
		 legend=false)
	
	# Save it in .png
	savefig(p, "wave-frec.png")
end

# Plots the spectrogram
function plot_spectrogram(s, fs, win=tukey(256, 0.5))

	# Transform it into a Vector
	s = vec(s)

	# Obtains the spectrogram
	spec = spectrogram(s, length(win), fs=fs, window=win)

	t, fr, pow = spec.time, spec.freq, spec.power

	# Rearrenge the negative frequencies
	neg_freq = findfirst(x -> x < 0, fr)

	if neg_freq !== nothing
		neg_pos = neg_freq - 1
		freq = [spec.freq[neg_freq:end]; spec.freq[1:neg_pos]]
		pow = [spec.power[neg_freq:end, :]; spec.power[1:neg_pos, :]]
	end

	# Plot it (HeatMap)
	hm = heatmap(t, fr, pow .+ eps() .|> log; seriescolor=:bluesreds,
		     title="Spectrogram", xlabel="Time [s]", ylabel="Freq [Hz]")

	# Save it in .png
	savefig(hm, "spec.png")
end

end # module

