# SequenceLogos Julia package

```julia
using SequenceLogos
using SequenceLogos: SequenceLogo, SequenceLogoSite, WeightedLetter, plot_sequence_logo_nt
logo = SequenceLogo([SequenceLogoSite([WeightedLetter(rand("TGAC"), randn()) for i=1:5]) for _=1:10])
plot_sequence_logo_nt(logo)
```

![Example sequence logo](/example.png)