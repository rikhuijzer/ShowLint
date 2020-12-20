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

    function unchanged(pat::Pattern, code::String)
        result = apply(pat, code)
        ok = result == code
        if !ok
            error("\"$result\" != \"$code\"")
        end
        return ok
    end

    @test apply(P[1], "AbstractArray{Int,1}") == "AbstractVector{Int}"
    @test apply(P[2], "if x === missing") == "if ismissing(x)"
    @test apply(P[2], "x !== missing") == "!ismissing(x)"
    @test apply(P[3], "map(x -> f(x), A)") == "map(f, A)"
    @test unchanged(P[3], "y = x -> f(x) ? a : b")
    @test unchanged(P[3], "x -> f.(x),")
    @test apply(P[4], "x == true") == "x"
    @test apply(P[4], "x == false") == "!x"
    @test apply(P[4], "x != false") == "!!x"
    @test apply(P[5], "if x == x") == "if true"
    @test apply(P[5], "x != x") == "false"
    @test unchanged(P[5], "a.x == x")
    @test unchanged(P[5], "x == x[1]")
    @test unchanged(P[5], "x == x:y")
    @test unchanged(P[5], "f(x) == x")
    @test apply(P[5], "f(x) == f(x)") == "true"
    @test apply(P[6], "findfirst(a, b) === nothing") == "!occursin(a, b)"
    @test apply(P[6], "findfirst(a, b) !== nothing") == "occursin(a, b)"
end
