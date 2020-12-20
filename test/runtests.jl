using ShowLint
using Test

SL = ShowLint

@testset "ShowLint" begin
    names = [r.name for r in SL.repositories]
    sorted = Base.sort(names)
    unique_and_sorted = unique(sorted)
    @test names == unique_and_sorted

    @test SL.prettify_loc(1000) == "1,000"
    
    include("patterns.jl")
end
