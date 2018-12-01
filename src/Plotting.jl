module Plotting

using DSP, FFTW
using Plots

export set_plot, plot_frec, plot_wave, plot_spectrogram, plot_zplane

# Sets backend renderer - PyPlot
function set_plot()
	pyplot()
end

# Plots wave in time
function plot_wave(s, fs;
		   plot_title="Modem Dialing",
		   image_name="wave")

	x_axis = (0:(length(s) - 1))./fs

	# Plot it
	p = plot(x_axis, s,
		 title="$plot_title - fs: $fs",
		 xlabel="Time [s]",
		 legend=false)
	
	# Save it in .png
	savefig(p, "$image_name.png")
end

# Plots wave in frecuency
function plot_frec(s, fs;
		   plot_title="Modem Dialing",
		   image_name="wave-frec")

	# FFT of the input wave
	X = abs.(fft(s))

	# Shift the returned spectrum
	Xshift = fftshift(X)

	X = X[1:div(end,2)]

	# In Hertz
	x_axis = (0:(1/length(X)):1) .* (fs/2)

	# In Omega (w)
	x_axis_omega = (-1:(1/length(Xshift)):1) .* fs

	x_neg = findfirst(x -> x >= -(fs/2), x_axis_omega)
	x_pos = findfirst(x -> x >= (fs/2), x_axis_omega)

	# Frecuency plot
	p = plot(x_axis, X,
		 title="$plot_title Frecuency Domain",
		 xlabel="Freq [Hz]",
		 legend=false);
	
	# Save it in .png
	savefig(p, "$image_name.png")

	# Omega plot
	p = plot(x_axis_omega[x_neg:x_pos], Xshift,
		 title="$plot_title Omega Frecuency Domain",
		 xlabel="Freq [w]",
		 legend=false);

	# Save it in .png
	savefig(p, "$image_name-omega.png")
end

# Plots the spectrogram
function plot_spectrogram(s, fs;
			  win=tukey(256, 0.5),
			  plot_title="Modem Dialing",
			  image_name="spec")

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
		     title="$plot_title Spectrogram", xlabel="Time [s]", ylabel="Freq [Hz]")

	# Save it in .png
	savefig(hm, "$image_name.png")
end

function plot_zplane(h, fc)

	fil = PolynomialRatio(h, [1])

	zpg = ZeroPoleGain(fil)

	zs = zpg.z
	ps = zpg.p
	
	length(zs) > length(ps) && (push!(ps, 0))

	scatter(real.(zs), imag.(zs),
		color=[:black],
		marker=:circle,
		label="Zero",
		title="Zero-Pole diagram - Filter: $fc Hz")

	scatter!(real.(ps), imag.(ps),
		color=[:red],
		marker=:diamond,
		label="Pole")

	savefig("zero-pole.png")
end

end # module

