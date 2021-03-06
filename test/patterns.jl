import JSON

using ShowLint: apply

@testset "Patterns" begin
    @test SL.patterns_have_valid_indexes()

    function unchanged(pat::Pattern, code::String)
        result = apply(pat, code)
        ok = result == code
        if !ok
            error("\"$result\" != \"$code\"")
        end
        return ok
    end

    P = SL.patterns

    @test apply(P[1], "rand(1)[1]") == "rand()"
    @test apply(P[1], "rand(f(), 1)[1]") == "rand(f())"
    @test apply(P[1], "rand(f(),1)[1]") == "rand(f())"
    @test apply(P[2], "if x === missing") == "if ismissing(x)"
    @test apply(P[2], "x !== missing") == "!ismissing(x)"
    @test apply(P[3], "map(x -> f(x), A)") == "map(f, A)"
    @test unchanged(P[3], "y = x -> f(x) ? a : b")
    @test unchanged(P[3], "x -> f.(x),")
    @test apply(P[4], "x == true") == "x"
    @test apply(P[4], "x == false") == "!x"
    @test apply(P[4], "x != false") == "!!x"
    @test apply(P[5], "if x == x\n") == "if true\n"
    @test apply(P[5], "if x != x") == "if false"
    @test unchanged(P[5], "a.x == x")
    @test unchanged(P[5], "x == x[1]")
    @test unchanged(P[5], "x == x:y")
    @test unchanged(P[5], "a/x == x")
    @test unchanged(P[5], "f(x) == x")
    @test unchanged(P[5], "f(a, x) == x)")
    @test unchanged(P[5], "1*x == x)")
    @test unchanged(P[5], "x == x′")
    @test unchanged(P[5], "2 * x == x)")
    # I have no clue how to fix this false positive.
    # @test unchanged(P[5], "x == x + 2)")
    @test unchanged(P[5], "6x == x)")
    @test unchanged(P[5], "x == x'")
    @test unchanged(P[5], "x == x^2'")
    @test apply(P[6], "findfirst(a, b) === nothing") == "!occursin(a, b)"
    @test apply(P[6], "findfirst(a, b) !== nothing") == "occursin(a, b)"
    @test apply(P[7], "findall(x -> x == false, Y)") == "findall(.!Y)"
    @test apply(P[8], "map(x -> !x, A)") == "map(!, A)"
    @test apply(P[8], "x -> ~x") == "~"
    @test unchanged(P[8], "x -> !x.y")
    @test unchanged(P[8], "x -> !x[1]")
    @test apply(P[9], "f(a, b; c = c)") == "f(a, b; c)"
    @test apply(P[10], "if a == b && a == b") == "if a == b"
    @test apply(P[10], "if a == b && a == b") == "if a == b"
    @test apply(P[10], "x.y[1] && x.y[1]") == "x.y[1]"
    # @test unchanged(P[10], "a < b && b")
    @test apply(P[11], "dirname(dirname(pathof(Foo)))") == "pkgdir(Foo)"
end
