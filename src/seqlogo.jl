struct SequenceLogo{L,W,C}
    letters::L
    weights::W
    colors::C
    function SequenceLogo(letters::AbstractVector, weights::AbstractMatrix, colors::AbstractVector)
        @assert length(letters) == length(colors) == size(weigths, 1)
        return new{typeof(letters), typeof(weights), typeof(colors)}(letters, weigths, colors)
    end
end

function protein_sequence_logo(weights::AbstractMatrix)
    if size(weights, 1) == 20
        return protein_sequence_logo_without_gaps(weights)
    else
        return protein_sequence_logo_with_gaps(weights)
    end
end

function protein_sequence_logo_with_gaps(weights::AbstractMatrix)
    letters = [collect(amino_acids()); '⊟']
    colors = aa_color.(letters)
    return SequenceLogo(letters, colors, weights)
end

function protein_sequence_logo_without_gaps(weights::AbstractMatrix)
    letters = collect(amino_acids())
    colors = aa_color.(letters)
    return SequenceLogo(letters, colors, weights)
end

amino_acids() = collect("ACDEFGHIKLMNPQRSTVWY")
amino_acid_colors() = error()

function aa_color(aa::Char)
    if aa in ('G', 'S', 'T', 'Y', 'C', 'Q', 'N') # polar
        return "green"
    elseif aa in ('K', 'R', 'H') # basic
        return "blue"
    elseif aa in ('D', 'E') # acidic
        return "red"
    elseif aa in ('A', 'V', 'L', 'I', 'P', 'W', 'F', 'M') # hydrophobic
        return "orange"
    else
        return "black"
    end
end

function rna_sequence_logo(weights::AbstractMatrix)
    if size(weights, 1) == 4
        return rna_sequence_logo_without_gaps(weights)
    else
        return rna_sequence_logo_with_gaps(weights)
    end
end

function rna_sequence_logo_with_gaps(weights::AbstractMatrix)
    letters = "ACGU⊟"
    colors = ["red", "blue", "blue", "red", "black"]
    return SequenceLogo(letters, colors, weights)
end

function rna_sequence_logo_without_gaps(weights::AbstractMatrix)
    letters = "ACGU"
    colors = ["red", "blue", "blue", "red"]
    return SequenceLogo(letters, colors, weights)
end

function dna_sequence_logo(weights::AbstractMatrix)
    if size(weights, 1) == 4
        return dna_sequence_logo_without_gaps(weights)
    else
        return dna_sequence_logo_with_gaps(weights)
    end
end

function dna_sequence_logo_with_gaps(weights::AbstractMatrix)
    letters = "ACGT⊟"
    colors = ["red", "blue", "blue", "red", "black"]
    return SequenceLogo(letters, colors, weights)
end

function dna_sequence_logo_without_gaps(weights::AbstractMatrix)
    letters = "ACGT"
    colors = ["red", "blue", "blue", "red"]
    return SequenceLogo(letters, colors, weights)
end
