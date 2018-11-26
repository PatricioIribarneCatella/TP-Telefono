# TP-Telefono

Análisis del audio de un discado telefónico (Señales y Sistemas)

### Ejecutar

- Dependencias: [_Julia_](https://docs.julialang.org/en/v1/index.html)
	- [_WAV_](https://juliaobserver.com/packages/WAV)
	- [_DSP_](https://juliaobserver.com/packages/DSP)
	- [_Plots_](https://juliaobserver.com/packages/Plots) (con el _backend_ de **Python** - [_pyplot_](https://docs.juliaplots.org/latest/examples/pyplot/))
	- [_PyPlot_](https://juliaobserver.com/packages/PyPlot) (utiliza la librería [**matpoltlib**](https://matplotlib.org/) de _Python_)
	- [_FFTW_](https://juliaobserver.com/packages/FFTW)
	- [_ArgParse_](https://juliaobserver.com/packages/ArgParse)
	- [_Match_](https://juliaobserver.com/packages/Match)

```bash
 $ julia SignalAnalisys.jl --audio=FILE.wav

 $ julia SignalGenerator.jl --sequence=SEQUENCE [--time=NUM(70 ms) | --silence-time=NUM(70 ms)]

	(SEQUENCE de la siguiente forma = "*_1_5_0_#"
		con al menos un '_' que simboliza un silencio)

 $ julia SignalDecoding.jl --audio=FILE.wav

 $ julia FundamentalPeriods.jl
```

