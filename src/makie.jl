import CairoMakie
import Makie

struct SeqLogo{W<:AbstractMatrix,L<:AbstractVecOrMat,C<:AbstractVecOrMat}
    weights::W
    letters::L
    colors::C
    function SeqLogo{W,L,C}(weights::W, letters::L, colors::C) where {W<:AbstractMatrix,L<:AbstractVector,C<:AbstractVector}
        @assert size(weights, 1) == length(letters) == length(colors)
        return new{W,L,C}(weights, letters, colors)
    end
    function SeqLogo{W,L,C}(weights::W, letters::L, colors::C) where {W<:AbstractMatrix,L<:AbstractMatrix,C<:AbstractMatrix}
        @assert size(weights) == size(letters) == size(colors)
        return new{W,L,C}(weights, letters, colors)
    end
end

function SeqLogo(weights::W, letters::L, colors::C) where {W,L,C}
    return SeqLogo{W,L,C}(weights, letters, colors)
end

function sort_logo(logo::SeqLogo)
    weights = similar(logo.weights)
    letters = similar(logo.letters, size(weights))
    colors = similar(logo.colors, size(weights))
    for i in axes(weights, 1)
        p = sortperm(logo.weights[i,:])
        weights[i, :] .= logo.weights[i, p]
        letters[i, :] .= logo.letters[p]
        colors[i, :] .= logo.colors[p]
    end
    return SeqLogo(weights, letters, colors)
end

function makie_sequence_logo!(
    ax::Makie.Axis, weights::AbstractMatrix, letters::AbstractMatrix, colors::AbstractMatrix
)
    @assert size(weights) == size(letters) == size(colors)

    x = repeat((1:size(weights, 2))', size(weights, 1), 1)
    y = zero(weights)
    for i in axes(weights, 1)
        y_pos = y_neg = 0.0
        for j in axes(weights, 2)
            if weights[i,j] > 0
                y_pos += weights[i,j]
                y[i,j] = y_pos
            elseif weights[i,j] < 0
                y_neg += weights[i,j]
                y[i,j] = y_neg
            end
        end
    end

    Makie.text!(ax, vec(x), vec(y); text=vec(letters), textsize=vec(abs.(weights)))
end

function makie_sequence_logo!(
    ax::Makie.Axis, weights::AbstractMatrix, letters::AbstractVector, colors::AbstractVector
)
    @assert size(weights, 1) == length(letters) == length(colors)
    weights_sorted, letters_sorted, colors_sorted = sort_sequence_logo(weights, letters, colors)
    return makie_seqlogo!(ax, weights_sorted, letters_sorted, colors_sorted)
end
