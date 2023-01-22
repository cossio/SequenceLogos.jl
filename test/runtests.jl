using Test: @test
using SequenceLogos: __example_fasta, makie_sequence_logo!
using Statistics: mean
using LogExpFunctions: xlogx
import FASTX
using Base: front
import Makie, CairoMakie

records = collect(FASTX.FASTA.Reader(open(__example_fasta())))
seqs = FASTX.sequence.(records)

NTs = "ACGU-"

function onehot(s::AbstractString)
    return reshape(collect(s), 1, length(s)) .== collect(NTs)
end
X = reshape(reduce(hcat, onehot.(seqs)), length(NTs), :, length(seqs))

p = reshape(mean(X; dims=3), size(X, 1), size(X, 2))
H = sum(-xlogx.(p) / log(2); dims=1)
cons = p .* (log2(5) .- H)


fig = Makie.Figure()
ax = Makie.Axis(fig[1,1]; width=500, height=200)
makie_sequence_logo!(ax, cons, collect(NTs), [:red, :blue, :orange, :green, :black])
fig
