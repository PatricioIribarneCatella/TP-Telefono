using WAV
using ArgParse

push!(LOAD_PATH, pwd())

using Filters

function main(wav_file)
	
	s, fs = wavread(wav_file)

	sequence = decode(s, fs)

	print("The dialing code is: ")
	for s in sequence
		print(s)
	end
	println()
end

if PROGRAM_FILE == "SignalFiltering.jl"

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


