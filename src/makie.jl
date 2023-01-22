function makie_sequence_logo!(
    ax::Makie.Axis, weights::AbstractMatrix, letters::AbstractMatrix, colors::AbstractMatrix
)
    @assert size(weights) == size(letters) == size(colors)

    # for i in axes(weights, 2)
    #     y_pos = y_neg = 0.0
    #     for k in axes(weights, 1)
    #         if weights[k,i] > 0
    #             y = y_pos
    #             y_pos += weights[k,i]
    #         elseif weights[k,i] < 0
    #             y = y_neg
    #             y_neg += weights[k,i]
    #         end

    #         Makie.text!(
    #             ax, i, y; text=string(letters[k,i]),
    #             textsize=abs(weights[k,i]), scale=Makie.Vec2(1/abs(weights[k,i]), 1),
    #             color=colors[k,i],
    #             markerspace=:data, align=(:center, :baseline), font="Arial bold"
    #         )
    #         Makie.scale
    #     end
    # end


   # return nothing

    x = repeat((1:size(weights, 2))', size(weights, 1), 1)
    y = zero(weights)
    for i in axes(weights, 2)
        y_pos = y_neg = 0.0
        for k in axes(weights, 1)
            if weights[k,i] > 0
                y[k,i] = y_pos + weights[k,i]/2
                y_pos += weights[k,i]
            elseif weights[k,i] < 0
                y[k,i] = y_neg + weights[k,i]/2
                y_neg += weights[k,i]
            end
        end
    end

    Makie.text!(
        ax, vec(x), vec(y); text=vec(letters),
        fontsize=vec([Makie.Vec2(1, abs(w)) for w in weights]),
        color=vec(colors),
        markerspace=:data, align=(:center, :baseline), font="Arial"
    )
end

function makie_sequence_logo!(
    ax::Makie.Axis, weights::AbstractMatrix, letters::AbstractVector, colors::AbstractVector
)
    @assert size(weights, 1) == length(letters) == length(colors)
    sorted_weights, sorted_letters, sorted_colors = sort_logo(weights, letters, colors)
    return makie_sequence_logo!(ax, sorted_weights, sorted_letters, sorted_colors)
end

function sort_logo(weights::AbstractMatrix, letters::AbstractVector, colors::AbstractVector)
    @assert size(weights, 1) == length(letters) == length(colors)
    sorted_weights = similar(weights)
    sorted_letters = similar(letters, size(weights))
    sorted_colors = similar(colors, size(weights))
    for i in axes(weights, 2)
        p = sortperm(weights[:,i])
        sorted_weights[:,i] .= weights[p,i]
        sorted_letters[:,i] .= letters[p]
        sorted_colors[:,i] .= colors[p]
    end
    return sorted_weights, sorted_letters, sorted_colors
end
