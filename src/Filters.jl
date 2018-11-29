module Filters

using DSP, FFTW

export decode

function get_filter(fs, width, fc)

	x_h = width .* (-0.05:(1/fs):0.05)

	h = sinc.(x_h)

	wc = ((2*pi)/fs) * fc

	h_bp = h .* cos.((0:(length(h) - 1)) .* wc)

	return h_bp
end

# Filter the signal for
# the given frecuency 'fc'
function filter_signal(s, fs; width, fc)

	# Create the filter
	bp = get_filter(fs, width, fc)

	# Filter the signal
	y = conv(s, bp)

	return y
end

function decode(s, fs)

	s = vec(s)
	
	# Filters
	y = filter_signal(s, fs, fc=697, width=40)

	y = filter_signal(s, fs, fc=770, width=40)

	y = filter_signal(s, fs, fc=852, width=40)

	y = filter_signal(s, fs, fc=941, width=40)

	y = filter_signal(s, fs, fc=1209, width=50)

	y = filter_signal(s, fs, fc=1336, width=50)

	y = filter_signal(s, fs, fc=1477, width=50)

	y = filter_signal(s, fs, fc=1633, width=50)
end

end # module
