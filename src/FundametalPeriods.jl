

function main()

	low_freqs = [697, 770, 852, 941]
	high_freqs = [1209, 1336, 1477, 1633]

	periods = Matrix{Float64}(undef, length(low_freqs), length(high_freqs))

	for i in range(1, length(low_freqs))
		for j in range(1, length(high_freqs))
			periods[i,j] = 1/gcd(low_freqs[i], high_freqs[j])
		end
	end
end

if PROGRAM_FILE == "FundametalPeriods.jl"
	main()
end
