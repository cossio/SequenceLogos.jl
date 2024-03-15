module SequenceLogos

import Makie
using LazyArtifacts: @artifact_str
using LazyArtifacts: LazyArtifacts

#include("logo.jl")
#include("color_funs.jl")
#include("pyplot.jl")
#include("bio.jl")
include("makie.jl")
include("artifacts.jl")

end # module
