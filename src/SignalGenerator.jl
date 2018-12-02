using ArgParse

push!(LOAD_PATH, pwd())

using Generator

# Main entry
function main(sequence, time, silence_time, noise, out)

	generate_signal(sequence,
			time=time,
			silence_time=silence_time,
			noise=noise,
			out_file=out)
end

if PROGRAM_FILE == "SignalGenerator.jl"

	# Parse the arguments
	s = ArgParseSettings("Audio dialing generator")

	@add_arg_table s begin
		"--sequence"
			help = "The sequence to be generated (ie: *1_5_0_#)" *
			       "The '_' represent the silences"
			required = true
		"--time"
			help = "The tone duration time in [ms]"
			default = 90
			arg_type = Int
		"--silence-time"
			help = "The silence duration time in [ms]"
			default = 70
			arg_type = Int
		"--noise"
			help = "Add white noise to the signal"
			default = false
			arg_type = Bool
		"--out"
			help = "Output file name with the file extension"
			default = "tone.wav"
	end

	parsed_args = parse_args(ARGS, s)

	main(parsed_args["sequence"],
	     parsed_args["time"],
	     parsed_args["silence-time"],
	     parsed_args["noise"],
	     parsed_args["out"])
end

