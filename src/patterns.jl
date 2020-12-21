struct Pattern
    id::Int
    title::String
    tags::Vector{String}
    description::String
    toml::String
end

val_rx = raw"[\w_\[\]:\.\\'*+-^′]+"
extend_val_rx_left = raw"(?<![+-\/*] )"
extend_val_rx_right = raw"(?! [+-\/*])"
fn_rx = raw"[\w_\.]+"

patterns = [
    Pattern(1, "Replace Array{T,1} with Vector{T}", ["julia"], 
        "Vector{T} and AbstractVector{T} are aliases for respectively Array{T,1} and AbstractArray{T,1}.",
        """
        match='Array{:[T],1}'

        rewrite='Vector{:[T]}'
        """
    ),
    Pattern(2, "Use ismissing", ["julia", "performance-decrease"], 
        "Note that `ismissing` can be slower, see <https://github.com/JuliaLang/julia/issues/27681>.",
        raw"""
        match=':[[var]] :[first~[=|!]]== missing' 

        rule='where rewrite :[first] { "=" -> "" }'

        rewrite=':[first]ismissing(:[var])'
        """
    ),
    Pattern(3, "Avoid x -> f(x)", ["julia"], 
        """
        From the [Julia Style Guide](https://docs.julialang.org/en/v1/manual/style-guide/).
        """,
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
        raw"""
        SA4000 in [staticcheck](https://staticcheck.io/docs/checks).

        Be careful when applying this pattern to situations where `a` can
        be of type `Missing`. 
        For example, `a == a` returns `missing` and not `true`.

        **Examples**
        ```
        julia> a == 1
        true

        julia> a == a
        true

        julia> a != a
        false
        ```
        """,
        """
        match=''':[x~$extend_val_rx_left$val_rx] :[bool~(=|!)]= :[x~$extend_val_rx_right$val_rx]'''

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
    ),
#    Pattern(8, "Avoid duplicate condition", ["julia"],
#        """
#        For example, replace
#        ```
#        if a == b
#            f()
#            g()
#        elseif a == b
#            h()
#        end
#        ```
#        with
#        ```
#        if a == b
#            f()
#            g()
#        end
#        ```
#        """,
#        raw"""
#        match='''
#        if :[cond~[^\\n]*]
#            :[a]
#        elseif :[cond~[^\\n]*]
#            :[b]'''
#
#        rewrite='''
#        if :[cond]
#            :[a]
#            :[b]'''
#        """
#    )
]

function patterns_have_valid_indexes()::Bool
    collect(1:length(patterns)) == [p.id for p in patterns]
end
