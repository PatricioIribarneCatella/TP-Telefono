push!(LOAD_PATH, pwd())

using Plotting, Filter

function main()

	fs = 8000

	low_freqs = [697, 770, 852, 941]
	high_freqs = [1209, 1336, 1477, 1633]

	for f in low_freqs
		y = get_filter(fs, 200, f)
		plot_zplane(y, f)
	end

	for f in high_freqs
		y = get_filter(fs, 200, f)
		plot_zplane(y, f)
	end
end

if PROGRAM_FILE == "ZeroPoleAnalysis.jl"
	main()
end
