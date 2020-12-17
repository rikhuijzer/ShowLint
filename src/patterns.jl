struct Pattern
    id::Int
    title::String
    tags::Vector{String}
    description::String
    toml::String
end

patterns = [
    Pattern(1, "Test: Add comment in Project.toml", ["test", "julia"], 
        "A test pattern to see if things work.", 
        """
        match='name = ":[name]"' 

        rewrite='''
        # A new comment.
        name = ":[name]"'''
        """
    ),
    Pattern(2, "Avoid var === nothing", ["julia"], 
        "Note that `ismissing` can be slower, see <https://github.com/JuliaLang/julia/issues/27681>.",
        """
        match='if :[var] === nothing' 

        rewrite='if isnothing(:[var])'
        """
    ),
    Pattern(3, "Avoid var !== nothing", ["julia"],
        "See [pattern 2](#2).",
        """
        match='if :[var] !== nothing'

        rewrite='if !isnothing(:[var])'
        """
    ),
    Pattern(4, "Replace Array{T,1} with Vector{T}", ["julia"], 
        "Vector{T} is an alias for Array{T,1}.",
        """
        match='Array{:[T],1}'

        rewrite='Vector{:[T]}'
        """
    )
]

function patterns_are_unique()::Bool
    length(patterns) == length(unique([p.id for p in patterns]))
end
@assert patterns_are_unique()
