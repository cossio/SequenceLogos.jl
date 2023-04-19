function makie_sequence_logo!(
    ax::Makie.Axis,
    weights::AbstractMatrix{<:Real},
    letters::AbstractMatrix{<:AbstractChar},
    colors::AbstractMatrix;
    font=("Arial", :bold),
)
    @assert size(weights) == size(letters) == size(colors)
    x, y = compute_positions(weights)
    for i in axes(weights, 1), j in axes(weights, 2)
        Makie.text!(
            ax, x[i,j], y[i,j];
            text=string(letters[i,j]),
            color=colors[i,j],
            fontsize=Makie.Vec2f(1, abs(weights[i,j])),
            #fontsize=Makie.Vec2f(1, 3),
            align=(:center, :center),
            markerspace=:data,
            space=:data
        )
    end

    # Makie.text!(
    #     ax, vec(x), vec(y);
    #     text=vec(string.(letters)),
    #     #text=vec(letters),
    #     color=vec(colors),
    #     #font,
    #     fontsize=vec(Makie.Vec2f.(1, abs.(weights))),
    #     #fontsize=Makie.Vec2f(1, 2),
    #     align=(:center, :center),
    #     #justification=0,
    #     #overdraw=true,
    #     #space=:data,
    #     markerspace=:data
    # )

    return
end

function compute_positions(weights::AbstractMatrix{<:Real})
    x = repeat((1:size(weights, 2))', size(weights, 1), 1)
    y = zero(weights)
    @assert size(x) == size(y) == size(weights)
    for i in axes(weights, 2)
        y_pos = y_neg = 0.0
        for k in axes(weights, 1)
            if weights[k,i] ≥ 0
                y[k,i] = y_pos + weights[k,i] / 2
                y_pos += weights[k,i]
            elseif weights[k,i] < 0
                y[k,i] = y_neg
                y_neg += weights[k,i]
            end
        end
    end
    return x, y
end

function makie_sequence_logo!(
    ax::Makie.Axis,
    weights::AbstractMatrix{<:Real},
    letters::AbstractVector{<:AbstractChar},
    colors::AbstractVector;
    kwargs...
)
    @assert size(weights, 1) == length(letters) == length(colors)
    sorted_weights, sorted_letters, sorted_colors = sort_logo(weights, letters, colors)
    return makie_sequence_logo!(ax, sorted_weights, sorted_letters, sorted_colors; kwargs...)
end

function sort_logo(
    weights::AbstractMatrix{<:Real},
    letters::AbstractVector{<:AbstractChar},
    colors::AbstractVector
)
    @assert size(weights, 1) == length(letters) == length(colors)
    sorted_weights = similar(weights)
    sorted_letters = similar(letters, size(weights))
    sorted_colors = similar(colors, size(weights))
    for i in axes(weights, 2)
        p = sortperm(weights[:,i]; by=abs)
        sorted_weights[:,i] .= weights[p,i]
        sorted_letters[:,i] .= letters[p]
        sorted_colors[:,i] .= colors[p]
    end
    return sorted_weights, sorted_letters, sorted_colors
end
