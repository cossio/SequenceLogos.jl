# SequenceLogos Julia package

[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://cossio.github.io/SequenceLogos.jl/stable)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://cossio.github.io/SequenceLogos.jl/dev)

```julia
using SequenceLogos
using SequenceLogos: SequenceLogo, SequenceLogoSite, WeightedLetter, plot_sequence_logo_nt
logo = SequenceLogo([SequenceLogoSite([WeightedLetter(rand("TGAC"), randn()) for i=1:5]) for _=1:10])
plot_sequence_logo_nt(logo)
```

![Example sequence logo](/example.png)

# Related

* https://github.com/cossio/Logomaker.jl
* https://github.com/cossio/MakieSequenceLogos.jl