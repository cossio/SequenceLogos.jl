# install Julia
curl -fsSL https://install.julialang.org | sh -s -- --yes 

# Julia startup file
mkdir -p ~/.julia/config
cp .devcontainer/julia_startup.jl ~/.julia/config/startup.jl

# Install Julia packages, registries, ...
/home/vscode/.juliaup/bin/julia .devcontainer/onCreate.jl