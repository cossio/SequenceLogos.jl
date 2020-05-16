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

"""
    logo_from_matrix(weights, alphabet)

Construct a `SequenceLogo` from a weight matrix of size (q, L), where `q` is
the number of possible letters and `L` the length of the sequence.
`alphabet` is a `String` containing the `q` possible letters.
"""
function logo_from_matrix(w::AbstractArray, alphabet::String)
    @assert size(w, 1) ≤ length(alphabet)
    # TODO: use BioSeqInt when it gets registered
    sites = Vector{SequenceLogoSite}(undef, size(w, 2))
    for i = 1:size(w, 2)
        letters = [WeightedLetter(alphabet[a], w[a,i]) for a = 1:size(w, 1)]
        sites[i] = SequenceLogoSite(letters)
    end
    return SequenceLogo(sites)
end

# TODO: use alphabet from BioSeqInt when it gets registered
logo_from_matrix_nt(w::AbstractMatrix) = logo_from_matrix(w, "ACGTX")
logo_from_matrix_aa(w::AbstractMatrix) = logo_from_matrix(w, "ACDEFGHIKLMNPQRSTVWYX")

"""
    conservation_matrix(P)

Given a matrix of frequencies `P` of size (q, L), where `q` is the number 
of possible letters and `L` the sequence length, returns the matrix of
conservations (as defined by Schneider and Stephens, 1990).
"""
function conservation_matrix(P::AbstractMatrix)
    q = size(P, 1)
    p = P ./ sum(P; dims=1)
    Smax = log2(q)
    Sobs = -sum(xlogx.(p); dims=1)
    return p .* (Smax .- Sobs)
end

"""
    conservation_matrix(P, M)

Similar to `conservation_matrix(P)`, but instead of a flat measure over
letters at each site, computes a KL divergence to a prior measure `M`.
"""
function conservation_matrix(P::AbstractMatrix, M::AbstractMatrix)
    @assert size(P) == size(M)
    q = size(P, 1)
    p = P ./ sum(P; dims=1)
    m = M ./ sum(M; dims=1)
    KL = sum(p .* xlogy.(p ./ m); dims=1)
    return p .* KL
end

function xlogx(x::Real)
    result = x * log(x)
    return ifelse(iszero(x), zero(result), result)
end

function xlogy(x::Real, y::Real)
    result = x * log(y)
    ifelse(iszero(x), zero(result), result)
end