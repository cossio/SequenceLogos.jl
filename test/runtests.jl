import Aqua, SequenceLogos
using Test: @testset

@testset "aqua" begin
    Aqua.test_all(SequenceLogos)
end
