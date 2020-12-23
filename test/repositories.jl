
@testset "Repositories" begin
    @test SL.repository_ordering_is_valid()
    @test SL.prettify_loc(1000) == "1,000"

    test_repo(; kwargs...) = Repo("https://example.com", "test/test"; kwargs...)

    p = Pattern(1, "Title", ["Julia", 1.3], "Description", "toml")
    r = test_repo(; predicates=[])
    @test SL.filter_patterns(r, [p]) == [p]
    r = test_repo()
    @test SL.filter_patterns(r, [p]) == []
    r = test_repo(; predicates=[SL.version(1.5)])
    @test SL.filter_patterns(r, [p]) == [p]
end
