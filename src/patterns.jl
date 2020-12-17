struct Pattern
    id::Int
    description::String
    tags::Vector{String}
    toml::String
end

patterns = [
    Pattern(1, "Test: Add comment in Project.toml", ["test", "julia"], """
        match='name = ":[name]"' 

        rewrite='''
        # A new comment.
        name = ":[name]"'''
        """
    ),
    Pattern(2, "Replace var === nothing", ["julia"], """
        match='if :[var] === nothing' 

        rewrite='if isnothing(:[var])'
        """
    )
]
