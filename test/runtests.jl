using ShowLint
using Test

SL = ShowLint

@testset "ShowLint" begin
    names = [r.name for r in SL.repositories]
    sorted = Base.sort(names)
    unique_and_sorted = unique(sorted)
    @test names == unique_and_sorted
    
    include("patterns.jl")
end
