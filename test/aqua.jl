import Aqua
import SequenceLogos
using Test: @testset

@testset verbose = true "aqua" begin
    Aqua.test_all(SequenceLogos; ambiguities = false)
end
