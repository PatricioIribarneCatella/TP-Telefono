using WAV
using DSP, FFTW
using Plots
using ArgParse

push!(LOAD_PATH, pwd())

function main(wav_file)
	
	s, fs = wavread(wav_file)

	s = vec(s)

	k = 100

	x_h = k .* (-1:(1/fs):1)

	h = sinc.(x_h)

	wc = ((2*pi)/fs) * 500

	h_bp = h .* cos.((1:length(h)) .* wc)

	H_bp = abs.(fft(h_bp))

	H_bp = H_bp[1:div(end, 2)]

	x_Hbp = (0:(1/length(H_bp)):1) .* (fs/2)

	p = plot(x_Hbp, H_bp, legend=false, xticks=(0:500:(fs/2)))
	
	savefig(p, "filter-500.png")
end

if PROGRAM_FILE == "SignalFiltering.jl"
	
	pyplot()

	main("dialing.wav")
end
