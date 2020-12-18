import JSON

@testset "Patterns" begin
    @test SL.patterns_have_valid_indexes()

    function apply(pat::Pattern, code::String; file_extension="jl")
        test_dir = joinpath(SL.clones_dir, "test", "test")
        rm(test_dir; recursive=true, force=true)
        mkpath(test_dir)

        code_file = joinpath(test_dir, "code.$file_extension")
        open(code_file, "w") do io
            write(io, code)
        end
        
        repo = Repo("test", "test", [SL.default])

        SL.apply(pat, repo; in_place=true)

        read(code_file, String)
    end

    P = SL.patterns

    @test apply(P[1], "AbstractArray{Int,1}") == "AbstractVector{Int}"
    @test apply(P[2], "if x === missing") == "if ismissing(x)"
    @test apply(P[2], "x !== missing") == "!ismissing(x)"
    @test apply(P[3], "map(x -> f(x), A)") == "map(f, A)"
    @test apply(P[3], "y = x -> f(x)") == "y = f"
end
