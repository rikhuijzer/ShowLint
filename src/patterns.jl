struct Pattern
    id::Int
    title::String
    tags::Vector{String}
    description::String
    toml::String
end

const val_rx = raw"[\w_\[\]:\.\\'*+-]+"
const fn_rx = raw"[\w_\.]+"

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
        raw"""
        match=':[[var]] :[first~[=|!]]== missing' 

        rule='where rewrite :[first] { "=" -> "" }'

        rewrite=':[first]ismissing(:[var])'
        """
    ),
    Pattern(3, "Avoid x -> f(x)", ["julia"], 
        "From the [Julia Style Guide](https://docs.julialang.org/en/v1/manual/style-guide/).",
        raw"""
        match=':[[x]] -> :[f~[\w_]*](:[x]):[end~(,|\n)]'

        rewrite=':[f]:[end]'
        """
    ),
    Pattern(4, "Omit comparison with boolean constant", ["generic"],
        "From [staticcheck](https://staticcheck.io/docs/checks).",
        """
        match=':[[var]] :[first~(=|!)]= :[bool~(true|false)]'

        rule='where 
            rewrite :[first] { "=" -> "" },
            rewrite :[bool] { "false" -> "!" },
            rewrite :[bool] { "true" -> "" }'

        rewrite=':[first]:[bool]:[var]'
        """
    ),
    Pattern(5, "Omit a == a and a != a", ["julia"],
        "SA4000 in [staticcheck](https://staticcheck.io/docs/checks).",
        """
        match=''':[x~$val_rx] :[bool~(=|!)]= :[x~$val_rx]'''

        rule='where
            rewrite :[bool] { "=" -> "true" },
            rewrite :[bool] { "!" -> "false" }'

        rewrite=':[bool]'
        """
    ),
    Pattern(6, "Avoid findfirst in conditional", ["julia"],
        """
        For example, instead of `findfirst('a', \"ab\") === nothing`,
        use `occursin('a', \"ab\")` or `contains` (Julia ≥1.5).
        """,
        """
        match='findfirst(:[a], :[b]) :[bool~(=|!)]== nothing'

        rule='where
            rewrite :[bool] { "!" -> "" },
            rewrite :[bool] { "=" -> "!" }'

        rewrite=':[bool]occursin(:[a], :[b])'
        """
    ),
    Pattern(7, "Avoid findall(x -> x == false, Y)", ["julia"],
        """
        Instead, use `findall(.!Y)`.
        """,
        """
        match='findall(:[x] -> :[x] == false, :[Y])'

        rewrite='findall(.!:[Y])'
        """
    )
]

function patterns_have_valid_indexes()::Bool
    collect(1:length(patterns)) == [p.id for p in patterns]
end
