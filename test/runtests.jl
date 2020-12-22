using ShowLint
using Test

SL = ShowLint

@testset "ShowLint" begin
    include("patterns.jl")
    include("repositories.jl")
end
