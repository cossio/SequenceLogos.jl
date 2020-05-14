#= Based on https://stackoverflow.com/questions/42615527/sequence-logos-in-matplotlib-aligning-xticks =#

using PyPlot

function aa_color(aa::Char)
    if aa in ('C',)
        return "green"
    elseif aa in ('F', 'W', 'Y')
        return "gold"
    elseif aa in ('Q', 'N', 'S', 'T')
        return "purple"
    elseif aa in ('V', 'L', 'I', 'M')
        return "black"
    elseif aa in ('K', 'R', 'H')
        return "blue"
    elseif aa in ('D', 'E')
        return "red"
    elseif aa in ('A', 'P', 'G')
        return "grey"
    else
        return "black"
    end
end

function nt_color(nt::Char) 
    if nt == 'G'
        return "orange"
    elseif nt == 'A'
        return "red"
    elseif nt == 'C'
        return "blue"
    elseif nt == 'T'
        return "darkgreen"
    else
        return "black"
    end
end

"""
    plot_sequence_logo(sequence_logo)

Plots a sequence logo.
"""
function plot_sequence_logo(logo::SequenceLogo, color_fun; thresh=0)
    sorted_logo = sort_letters(logo)
    figsize = (max(round(Int, length(sorted_logo.sites)/3), 2), 3)
    fig, ax = matplotlib.pyplot.subplots(figsize=figsize)
    y_min = y_max = 0.0
    for (x, site) in enumerate(sorted_logo.sites)
        y_pos = y_neg = 0.0
        for weighted_letter in site.weighted_letters
            w = abs(weighted_letter.weight)
            l = weighted_letter.letter
            w ≤ thresh && continue
            if weighted_letter.weight > 0
                letter_at(l, color_fun(l), (x, y_pos), w, ax)
                y_pos += w
            elseif weighted_letter.weight < 0
                y_neg -= w
                letter_at(l, color_fun(l), (x, y_neg), w, ax)
            end
        end
        y_max = max(y_max, y_pos)
        y_min = min(y_min, y_neg)
    end
    if y_min < 0
        y_max = max(y_max, -y_min)
        y_min = -y_max
    end
    matplotlib.pyplot.xlim((0, length(sorted_logo.sites) + 1))
    matplotlib.pyplot.ylim((y_min, y_max))
    matplotlib.pyplot.tight_layout()
    matplotlib.pyplot.show()
end

plot_sequence_logo_aa(logo::SequenceLogo; thresh=0) = plot_sequence_logo(logo, aa_color; thresh=thresh)
plot_sequence_logo_nt(logo::SequenceLogo; thresh=0) = plot_sequence_logo(logo, nt_color; thresh=thresh)

"""
    letter_at(letter, color, (x, y), yscale, ax)

Adds a letter to the current plot, at the given position.
"""
function letter_at(letter::Char, color::String, (x, y), yscale::Real, ax)
    fp = matplotlib.font_manager.FontProperties(family="Arial", weight="bold") 
    globscale = 1.35
    GLYPHS = Dict(
            'T' => matplotlib.textpath.TextPath((-0.305, 0), "T", size=1, prop=fp),
            'G' => matplotlib.textpath.TextPath((-0.384, 0), "G", size=1, prop=fp),
            'A' => matplotlib.textpath.TextPath((-0.350, 0), "A", size=1, prop=fp),
            'C' => matplotlib.textpath.TextPath((-0.366, 0), "C", size=1, prop=fp)
        )
    text = get(GLYPHS, letter, matplotlib.textpath.TextPath((-0.35, 0), "C", size=1, prop=fp))
    t = (matplotlib.transforms.Affine2D().scale(1 * globscale, yscale * globscale) +
         matplotlib.transforms.Affine2D().translate(x, y) + ax.transData)
    p = matplotlib.patches.PathPatch(text, lw=0, fc=color, transform=t)
    ax.add_artist(p)
    return p
end