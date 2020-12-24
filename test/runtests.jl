using ShowLint
using Test

SL = ShowLint

@testset "ShowLint" begin
    SL.write_configs()
    include("patterns.jl")
    include("repositories.jl")

    SL.clone_repositories(; production=false)
    SL.create_repo_pages(; production=false)
end
