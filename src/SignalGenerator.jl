push!(LOAD_PATH, pwd())

using Generator

function main(sequence)

	generate_signal(sequence, time=0.090)
end

if PROGRAM_FILE == "SignalGenerator.jl"

	main(["*", "_", "1", "_", "5", "_", "0", "_", "#"])
end

