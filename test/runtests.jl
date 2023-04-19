using Test: @test
using SequenceLogos: __example_fasta, makie_sequence_logo!
using Statistics: mean
using LogExpFunctions: xlogx
import FASTX
using Base: front
import Makie
import CairoMakie

records = collect(FASTX.FASTA.Reader(open(__example_fasta())))
seqs = FASTX.sequence.(records)

NTs = "ACGU⊟"

function onehot(s::AbstractString)
    return reshape(collect(s), 1, length(s)) .== collect(NTs)
end
X = reshape(reduce(hcat, onehot.(seqs)), length(NTs), :, length(seqs))

p = reshape(mean(X; dims=3), size(X, 1), size(X, 2))
H = sum(-xlogx.(p) / log(2); dims=1)
weights = p .* (log2(5) .- H)

weights .= mean(weights)

weights = [
    1.0 1.0;
    2.0 3.0
]
letters = ['A'; 'C']
colors = [:red; :blue]

fig = Makie.Figure()
ax = Makie.Axis(fig[1,1]; width=1000, height=200)
tmp = makie_sequence_logo!(ax, weights, letters, colors)
Makie.resize_to_layout!(fig)
fig

Makie.Vec2f.(weights)
