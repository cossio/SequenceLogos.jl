import Pkg

Pkg.Registry.add(Pkg.RegistrySpec(url="https://github.com/cossio/CossioJuliaRegistry.git"))
Pkg.Registry.add("General")

Pkg.add([
    "Revise",
    "Makie",
    "CairoMakie"
])