push!(LOAD_PATH, pwd())

using Generator

function main(sequence)

	generate_signal(sequence)
end

if PROGRAM_FILE == "SignalGenerator.jl"

	main(["*", "s", "1", "s", "5", "s", "0", "s", "#"])
end

