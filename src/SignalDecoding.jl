using WAV
using ArgParse

push!(LOAD_PATH, pwd())

using Decoder

# Main entry
function main(wav_path)
	
	# Read the WAV file
	s, fs = wavread(wav_path)

	sequence = decode(s, fs)

	print("The dialing code is: ")
	for s in sequence
		print(s)
	end
	println()
end

if PROGRAM_FILE == "SignalDecoding.jl"

	# Parse the argument
	s = ArgParseSettings("Audio dialing decoder")

	@add_arg_table s begin
		"--audio"
		help = "The audio to be decoded"
		required = true
	end

	parsed_args = parse_args(ARGS, s)

	main(parsed_args["audio"])
end

