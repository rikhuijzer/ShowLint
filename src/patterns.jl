struct Pattern
    id::Int
    title::String
    tags::Vector{String}
    description::String
    toml::String
end

patterns = [
    Pattern(1, "Prefix project name with Test.", ["test", "julia"], 
        "A test pattern.", 
        """
        match='name = ":[name]"' 

        rewrite='''
        name = "Test:[name]"'''
        """
    ),
    Pattern(2, "Use ismissing instead of === and !==", ["julia"], 
        "Note that `ismissing` can be slower, see <https://github.com/JuliaLang/julia/issues/27681>.",
        """
        match=':[var~[^;]] :[neg~[=|!]]== missing' 

        rule='where rewrite :[neg] { "=" -> "" }'

        rewrite=':[neg]ismissing(:[var])'
        """
    ),
    Pattern(3, "Replace Array{T,1} with Vector{T}", ["julia"], 
        "Vector{T} and AbstractVector{T} are aliases for respectively Array{T,1} and AbstractArray{T,1}.",
        """
        match='Array{:[T],1}'

        rewrite='Vector{:[T]}'
        """
    )
]

function patterns_have_valid_indexes()::Bool
    collect(1:length(patterns)) == [p.id for p in patterns]
end
