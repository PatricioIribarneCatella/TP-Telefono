module Filters

using DSP, FFTW

export filter_signal

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

end # module
