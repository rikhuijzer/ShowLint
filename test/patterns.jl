import JSON

@testset "Patterns" begin
    @test S.patterns_have_valid_indexes()

    function apply(pat::Pattern, code::String; file_extension="jl")
        test_dir = joinpath(S.clones_dir, "test", "test")
        rm(test_dir; recursive=true, force=true)
        mkpath(test_dir)

        code_file = joinpath(test_dir, "code.$file_extension")
        open(code_file, "w") do io
            write(io, code)
        end
        
        repo = Repo("test", "test", [S.default])

        S.apply(pat, repo; in_place=true)

        read(code_file, String)
    end

    pats = S.patterns

    @test apply(pats[2], "if x === missing") == "if ismissing(x)"
    @test apply(pats[2], "x !== missing") == "!ismissing(x)"
end
