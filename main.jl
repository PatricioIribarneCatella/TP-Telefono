using DSP, WAV, PyPlot

# Read the WAV file
s, fs = wavread("modemDialing.wav")

# Plot the samples
title("Modem Dialing plot")
x_axis = (0:(length(s) - 1))./fs
plot(x_axis, s)
xlabel("Time [s]")

