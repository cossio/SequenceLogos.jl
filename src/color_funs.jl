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

function nt_color(nt::Char) 
    if nt == 'G'
        return "orange"
    elseif nt in ('T', 'U')
        return "red"
    elseif nt == 'C'
        return "blue"
    elseif nt == 'A'
        return "green"
    else
        return "black"
    end
end
