using DSP, WAV, PyPlot

# Read the WAV file
s, fs = wavread("modemDialing.wav")

# Plot the samples
plot(0:1/fs:(length(s)-1)/fs, s)
xlabel("Time [s]")

