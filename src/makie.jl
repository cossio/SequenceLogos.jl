import CairoMakie
import Makie

"""
    letter_at(letter, color, (x, y), yscale)

Adds a letter to the current plot, at the given position.
"""
function letter_at!(ax::Makie.Axis, letter::Char, color::String, (x, y), yscale::Real)
    Makie.text!(ax, position = (x, y), align = (:center, :center), space = :data)
    # TODO: INcomplete!
    error("This function is incomplete")

    fp = matplotlib.font_manager.FontProperties(family="Arial", weight="bold")
    globscale = 1.35
    GLYPHS = Dict(
            'T' => matplotlib.textpath.TextPath((-0.305, 0), "T", size=1, prop=fp),
            'G' => matplotlib.textpath.TextPath((-0.384, 0), "G", size=1, prop=fp),
            'A' => matplotlib.textpath.TextPath((-0.350, 0), "A", size=1, prop=fp),
            'C' => matplotlib.textpath.TextPath((-0.366, 0), "C", size=1, prop=fp),
            'W' => matplotlib.textpath.TextPath((-0.470, 0), "W", size=1, prop=fp),
            'I' => matplotlib.textpath.TextPath((-0.152, 0), "I", size=1, prop=fp)
        )
    text = get(GLYPHS, letter, matplotlib.textpath.TextPath((-0.35, 0), string(letter), size=1, prop=fp))
    t = (matplotlib.transforms.Affine2D().scale(1 * globscale, yscale * globscale) +
         matplotlib.transforms.Affine2D().translate(x, y) + ax.transData)
    p = matplotlib.patches.PathPatch(text, lw=0, fc=color, transform=t)
    ax.add_artist(p)
    return p
end
