# SequenceLogos Julia package

[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://cossio.github.io/SequenceLogos.jl/stable)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://cossio.github.io/SequenceLogos.jl/dev)

![](https://github.com/cossio/SequenceLogos.jl/workflows/CI/badge.svg)
[![codecov](https://codecov.io/gh/cossio/SequenceLogos.jl/branch/master/graph/badge.svg?token=7AK23CD8Z7)](https://codecov.io/gh/cossio/SequenceLogos.jl)
![GitHub repo size](https://img.shields.io/github/repo-size/cossio/SequenceLogos.jl)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/cossio/SequenceLogos.jl)

```julia
using SequenceLogos
using SequenceLogos: SequenceLogo, SequenceLogoSite, WeightedLetter, plot_sequence_logo_nt
logo = SequenceLogo([SequenceLogoSite([WeightedLetter(rand("TGAC"), randn()) for i=1:5]) for _=1:10])
plot_sequence_logo_nt(logo)
```

![Example sequence logo](/example.png)

# Related

* https://github.com/cossio/Logomaker.jl