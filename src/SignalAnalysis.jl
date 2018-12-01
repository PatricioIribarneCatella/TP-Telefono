using WAV
using ArgParse

push!(LOAD_PATH, pwd())

using Plotting

# Main entry
function main(wav_file)
	
	# Read the WAV file
	s, fs = wavread(wav_file)

	plot_wave(s, fs)
	plot_frec(s, fs)
	plot_spectrogram(s, fs)
end

if PROGRAM_FILE == "SignalAnalisys.jl"
	
	# Set backend renderer
	set_plot()

	# Parse the argument
	s = ArgParseSettings("Audio dialing analisys")

	@add_arg_table s begin
		"--audio"
		help = "The audio file (WAV)"
		required = true
	end

	parsed_args = parse_args(ARGS, s)

	main(parsed_args["audio"])
end


