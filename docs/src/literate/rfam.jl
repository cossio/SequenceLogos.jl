#=
# SequenceLogos examples with RFAM
=#

import SequenceLogos
using LazyArtifacts: LazyArtifacts, @artifact_str
import Makie
import CairoMakie
using Statistics: mean
using LogExpFunctions: xlogx


import PyPlot

# Fetch RNA family alignment RF00162 from RFAM (pre-stored as a Github Gist)
fasta_path = joinpath(artifact"RF00162_trimmed", "RF00162-trimmed.afa")
nothing #hide

# Parse lines
seqs = String[]
for line in eachline(fasta_path)
    if startswith(line, '>')
        continue
    else
        push!(seqs, line)
    end
end

# RNA nucleotides

NTs = "ACGU-";

# One-hot representation

function onehot(s::String)
    return reshape(collect(s), 1, length(s)) .== collect(NTs)
end
X = reshape(reduce(hcat, onehot.(seqs)), 5, :, length(seqs));
p = reshape(mean(X; dims=3), size(X)[1:2]...)
xlog2x(x) = xlogx(x) / log(oftype(x,2))
H = sum(-xlog2x.(p); dims=1)

weights = cons = p .* (log2(5) .- H)

letters = collect(NTs)
colors = [:red, :red, :blue, :blue, :black]

fig = Makie.Figure()
ax = Makie.Axis(fig[1,1], width=600, height=100)
SequenceLogos.makie_sequence_logo!(ax, cons, letters, colors)
Makie.resize_to_layout!(fig)
fig

function plot_example()
    fig = Makie.Figure()
    ax = Makie.Axis(fig[1,1], width=600, height=100)
    SequenceLogos.makie_sequence_logo!(ax, cons, letters, colors)
    Makie.resize_to_layout!(fig)
    fig
end


logo_from_matrix(w::AbstractMatrix) = SequenceLogos.logo_from_matrix(w, replace(NTs, '-' => '⊟'))


function seqlogo_entropic(p::AbstractMatrix; max_ylim=true)
    @assert size(p, 1) == 5 # nucleotides + gap
    w = p ./ sum(p; dims=1)
    H = sum(-xlog2x.(w); dims=1)
    @assert all(0 .≤ H .≤ log2(5))
    SequenceLogos.plot_sequence_logo(logo_from_matrix(w .* (log2(5) .- H)), SequenceLogos.nt_color)
    max_ylim && PyPlot.matplotlib.pyplot.ylim((0, log2(5)))
    PyPlot.matplotlib.pyplot.ylabel("conservation (bits)")
    PyPlot.matplotlib.pyplot.xlabel("site")
    return nothing
end

# Plot!

PyPlot.matplotlib.pyplot.figure(figsize=(15,2))
seqlogo_entropic(reshape(mean(X; dims=3), 5, 108))
PyPlot.matplotlib.pyplot.gcf()
