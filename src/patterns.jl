struct Pattern
    id::Int
    title::String
    tags::Vector{String}
    description::String
    toml::String
end

patterns = [
    Pattern(1, "Replace Array{T,1} with Vector{T}", ["julia"], 
        "Vector{T} and AbstractVector{T} are aliases for respectively Array{T,1} and AbstractArray{T,1}.",
        """
        match='Array{:[T],1}'

        rewrite='Vector{:[T]}'
        """
    ),
    Pattern(2, "Use ismissing", ["julia"], 
        "Note that `ismissing` can be slower, see <https://github.com/JuliaLang/julia/issues/27681>.",
        """
        match=':[[var]] :[first~[=|!]]== missing' 

        rule='where rewrite :[first] { "=" -> "" }'

        rewrite=':[first]ismissing(:[var])'
        """
    ),
    Pattern(3, "Avoid x -> f(x)", ["julia"], 
        "From the Julia [Style Guide](https://docs.julialang.org/en/v1/manual/style-guide/).",
        """
        match=':[[var]] -> :[function](:[var])' 

        rewrite=':[function]'
        """
    )
]

function patterns_have_valid_indexes()::Bool
    collect(1:length(patterns)) == [p.id for p in patterns]
end
