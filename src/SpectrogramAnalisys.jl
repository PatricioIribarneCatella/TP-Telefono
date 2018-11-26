using WAV
using DSP

push!(LOAD_PATH, pwd())

using Plotting

function main(wav_file)

	s, fs = wavread(wav_file)
	
	# Tukey Windows

	plot_spectrogram(s, fs, win=tukey(300, 0.5),
			 plot_title="Spectrogram, window: Tukey(300)",
			 image_name="spec-tuk-300")

	plot_spectrogram(s, fs, win=tukey(200, 0.5),
			 plot_title="Spectrogram, window: Tukey(200)",
			 image_name="spec-tuk-200")

	plot_spectrogram(s, fs, win=tukey(100, 0.5),
			 plot_title="Spectrogram, window: Tukey(100)",
			 image_name="spec-tuk-100")

	# Hanning Windows

	plot_spectrogram(s, fs, win=tukey(300, 1),
			 plot_title="Spectrogram, window: Hanning(300)",
			 image_name="spec-hann-300")

	plot_spectrogram(s, fs, win=tukey(200, 1),
			 plot_title="Spectrogram, window: Hanning(200)",
			 image_name="spec-hann-200")

	plot_spectrogram(s, fs, win=tukey(100, 1),
			 plot_title="Spectrogram, window: Hanning(100)",
			 image_name="spec-hann-100")

	# Rectangular Window
	
	plot_spectrogram(s, fs, win=tukey(300, 0),
			 plot_title="Spectrogram, window: Rect(300)",
			 image_name="spec-rect-300")

	plot_spectrogram(s, fs, win=tukey(200, 0),
			 plot_title="Spectrogram, window: Rect(200)",
			 image_name="spec-rect-200")

	plot_spectrogram(s, fs, win=tukey(100, 0),
			 plot_title="Spectrogram, window: Rect(100)",
			 image_name="spec-rect-100")

	# Bartlett Windows
	
	plot_spectrogram(s, fs, win=bartlett(300),
			 plot_title="Spectrogram, window: Bartlett(300)",
			 image_name="spec-bart-300")

	plot_spectrogram(s, fs, win=bartlett(200),
			 plot_title="Spectrogram, window: Bartlett(200)",
			 image_name="spec-bart-200")

	plot_spectrogram(s, fs, win=bartlett(100),
			 plot_title="Spectrogram, window: Bartlett(100)",
			 image_name="spec-bart-100")


end

if PROGRAM_FILE == "SpectrogramAnalisys.jl"

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
