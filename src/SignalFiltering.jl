using WAV
using ArgParse

push!(LOAD_PATH, pwd())

using Filters
using Plotting

function main(wav_file)
	
	s, fs = wavread(wav_file)

	s = vec(s)

	# Filters
	y = filter_signal(s, fs, fc=697, width=40)
	plot_wave(y, fs,
		  plot_title="Siganl filtered fc:697",
		  image_name="sign-filt-697")

	y = filter_signal(s, fs, fc=770, width=40)
	plot_wave(y, fs,
		  plot_title="Siganl filtered fc:770",
		  image_name="sign-filt-770")

	y = filter_signal(s, fs, fc=852, width=40)
	plot_wave(y, fs,
		  plot_title="Siganl filtered fc:852",
		  image_name="sign-filt-852")

	y = filter_signal(s, fs, fc=941, width=40)
	plot_wave(y, fs,
		  plot_title="Siganl filtered fc:941",
		  image_name="sign-filt-941")

	y = filter_signal(s, fs, fc=1209, width=50)
	plot_wave(y, fs,
		  plot_title="Siganl filtered fc:1209",
		  image_name="sign-filt-1209")

	y = filter_signal(s, fs, fc=1336, width=50)
	plot_wave(y, fs,
		  plot_title="Siganl filtered fc:1336",
		  image_name="sign-filt-1336")

	y = filter_signal(s, fs, fc=1477, width=50)
	plot_wave(y, fs,
		  plot_title="Siganl filtered fc:1477",
		  image_name="sign-filt-1477")

	y = filter_signal(s, fs, fc=1633, width=50)
	plot_wave(y, fs,
		  plot_title="Siganl filtered fc:1633",
		  image_name="sign-filt-1633")
end

if PROGRAM_FILE == "SignalFiltering.jl"

	set_plot()

	# Parse the argument
	s = ArgParseSettings("Audio filtering decoder")

	@add_arg_table s begin
		"--audio"
		help = "The audio to be decoded"
		required = true
	end

	parsed_args = parse_args(ARGS, s)

	main(parsed_args["audio"])
end


