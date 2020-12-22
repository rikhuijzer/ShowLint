
@testset "Repositories" begin
    @test SL.repository_ordering_is_valid()
    @test SL.prettify_loc(1000) == "1,000"


end
