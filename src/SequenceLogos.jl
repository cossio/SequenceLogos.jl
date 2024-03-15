module SequenceLogos

import Makie
using LazyArtifacts: @artifact_str
using LazyArtifacts: LazyArtifacts

#include("logo.jl")
#include("color_funs.jl")
#include("pyplot.jl")
#include("bio.jl")
include("makie.jl")

function __example_fasta()
    return joinpath(artifact"RF00162_trimmed", "RF00162-trimmed.afa")
end

end # module
