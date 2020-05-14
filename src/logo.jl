struct WeightedLetter
    letter::Char
    weight::Float64
end

struct SequenceLogoSite
    weighted_letters::Vector{WeightedLetter}
end

struct SequenceLogo
    sites::Vector{SequenceLogoSite}
end

"""
    sort_letters(site)

Sorts the letters in a site in order of increasing absolute weight.
"""
function sort_letters(site::SequenceLogoSite)
    sorted_letters = sort(site.weighted_letters; by=(l -> abs(l.weight)))
    return SequenceLogoSite(sorted_letters)
end

"""
    sort_letters(logo; remove_duplicates=true)

Sorts the letters in all sites in order of increasing absolute weight.
"""
function sort_letters(logo::SequenceLogo; remove_duplicates=true)
    if remove_duplicates
        logo = remove_duplicate_letters(logo)
    end
    sorted_sites = [sort_letters(site) for site in logo.sites]
    return SequenceLogo(sorted_sites)
end

"""
    remove_duplicate_letters(logo)

Removes duplicate letters at each site (summing their weights).
"""
function remove_duplicate_letters(logo::SequenceLogo)
    dedup_sites = Vector{SequenceLogoSite}()
    for site in logo.sites
        d = Dict{Char,Float64}()
        for weighted_letter in site.weighted_letters
            l, w = weighted_letter.letter, weighted_letter.weight
            d[l] = get(d, l, zero(w)) + w
        end
        site = SequenceLogoSite([WeightedLetter(l,w) for (l,w) in d])
        push!(dedup_sites, site)
    end
    return SequenceLogo(dedup_sites)
end