push!(LOAD_PATH, pwd())

using Plotting, Filter

function main()

	fs = 8000

	low_freqs = [697, 770, 852, 941]
	high_freqs = [1209, 1336, 1477, 1633]

	for f in low_freqs
		y = get_filter(fs, 200, f)
		plot_phase(y, f, fs)
	end

	for f in high_freqs
		y = get_filter(fs, 200, f)
		plot_phase(y, f, fs)
	end
end

if PROGRAM_FILE == "PhaseAnalysis.jl"

	set_plot()

	main()
end
