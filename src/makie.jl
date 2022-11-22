import CairoMakie
import Makie

function makie_seqlogo!(
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

function makie_seqlogo!(
    ax::Makie.Axis, weights::AbstractMatrix, letters::AbstractVector, colors::AbstractVector
)
    @assert size(weights, 1) == length(letters) == length(colors)
    weights_sorted, letters_sorted, colors_sorted = sort_logo(weights, letters, colors)
    return makie_seqlogo!(ax, weights_sorted, letters_sorted, colors_sorted)
end

function sort_logo(weights::AbstractMatrix, letters::AbstractVector, colors::AbstractVector)
    @assert size(weights, 1) == length(letters) == length(colors)
    weights_sorted = similar(weights)
    letters_sorted = similar(letters, size(weights))
    colors_sorted = similar(colors, size(weights))
    for i in axes(weights, 1)
        p = sortperm(weights[i,:])
        weights_sorted[i, :] .= weights[i, p]
        letters_sorted[i, :] .= letters[p]
        colors_sorted[i, :] .= colors[p]
    end
    return weights_sorted, letters_sorted, colors_sorted
end
