
"""
$(TYPEDEF)
$(TYPEDFIELDS)

where `toml` is a Comby configuration.
"""
struct Pattern
    id::Int
    title::String
    tags::Vector{Any}
    description::String
    toml::String
end

unary_operators = ['!', '~', '+', '-']

val_rx = raw"[\w_\[\]:\.\\'*+-^′]+"
extend_val_rx_left = raw"(?<![+-\/*] )"
extend_val_rx_right = raw"(?! [+-\/*])"
fn_rx = raw"[\w_\.]+"

patterns = [
    Pattern(1, "Use rand() instead of rand(1)[1]", ["julia"],
        """
        According to [DNF](https://stackoverflow.com/questions/65403410/), many people use 
        ```
        julia> using Random

        julia> Random.seed!(1234); rand(1)[1]
        0.5908446386657102
        ```
        instead of (the more performant)
        ```
        julia> Random.seed!(1234); rand()
        0.5908446386657102
        ```
        """,
        """
        [p1a]
        match="rand(1)[1]"
        rewrite="rand()"

        [p1b]
        match="rand(:[a],:[space~[ ]*]1)[1]"
        rewrite="rand(:[a])"
        """
    ),
    Pattern(2, "Use ismissing", ["julia", "performance-decrease"], 
        """
        This pattern is disabled for now by default, due to discussion at
        <https://discourse.julialang.org/t/ismissing-x-versus-x-missing/52171>.
        """,
        raw"""
        [p2]
        match=':[[var]] :[first~[=|!]]== missing' 

        rule='where rewrite :[first] { "=" -> "" }'

        rewrite=':[first]ismissing(:[var])'
        """
    ),
    Pattern(3, "Avoid x -> f(x)", ["julia"], 
        """
        From the [Julia Style Guide](https://docs.julialang.org/en/v1/manual/style-guide/).
        For unary operators, such as `x -> !x`, see [pattern 8](#8).

        **Example**
        ```
        julia> f(x) = 2x
        f (generic function with 1 method)

        julia> map(x -> f(x), [1, 2])
        2-element Array{Int64,1}:
         2
         4

        julia> map(f, [1, 2])
        2-element Array{Int64,1}:
         2
         4
        ```
        """,
        raw"""
        [p3]
        match=':[[x]] -> :[f~[\w_]*](:[x]):[end~(,|\n)]'

        rewrite=':[f]:[end]'
        """
    ),
    Pattern(4, "Omit comparison with boolean constant", ["generic"],
        "From [staticcheck](https://staticcheck.io/docs/checks).",
        """
        [p4]
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

        Be careful when applying this pattern to situations where `a` can be of type `Missing`. 
        For example, `a == a` returns `missing` and not `true`.
        On the other hand, `if missing` returns an error, so maybe this isn't a valid argument.

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
        [p5]
        match=''':[x~$extend_val_rx_left$val_rx] :[bool~(=|!)]= :[x~$extend_val_rx_right$val_rx]'''

        rule='where
            rewrite :[bool] { "=" -> "true" },
            rewrite :[bool] { "!" -> "false" }'

        rewrite=':[bool]'
        """
    ),
    Pattern(6, "Avoid comparing findfirst to nothing", ["julia"],
        """
        For example, instead of `findfirst('a', \"ab\") === nothing`, use `occursin('a', \"ab\")` or `contains` (Julia ≥1.5).
        """,
        """
        [p6]
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
        [p7]
        match='findall(:[x] -> :[x] == false, :[Y])'

        rewrite='findall(.!:[Y])'
        """
    ),
    Pattern(8, "Use unary operator without anonymous function", ["julia"],
        """
        This is an extension of [pattern 3](#3) for the unary operators:
        `$(join(unary_operators, "`, `"))`.

        **Example**
        ```
        julia> map(x -> !x, [true, missing])
        2-element Array{Union{Missing, Bool},1}:
         false
              missing

        julia> map(!, [true, missing]
        2-element Array{Union{Missing, Bool},1}:
         false
              missing
        ```
        """,
        """
        [p8]
        match=':[[x]] -> :[unary~[$(join(unary_operators))]]:[x~[\\w\\_\\[\\]\\.]+]'

        rewrite=':[unary]'
        """
    ),
    Pattern(9, "Abbreviate keyword argument values", ["julia", 1.5],
        """
        From [Julia 1.5 onwards](https://julialang.org/blog/2020/08/julia-1.5-highlights)
        it is possible to abbreviate
        ```
        printstyled("text"; color = color)
        ```
        to
        ```
        printstyled("text"; color)
        ```
        """,
        """
        [p9]
        match="(:[a]; :[c] = :[c])"
        rewrite="(:[a]; :[c])"
        """
    ), 
    Pattern(10, "Replace P && P by P", ["julia"],
        """
        The statement `P && P` is logically equivalent to `P`.
        This is called a micro-clone \\citep{pTonder2016}.

        ### Example
        ```
        julia> P = 3 < 1
        false

        julia> P && P
        false

        julia> P
        false
        ```
        """,
        """
        [p10a]
        match=" :[var] && :[var]"
        rewrite=" :[var]"
        """
    )
]

function patterns_have_valid_indexes()::Bool
    collect(1:length(patterns)) == [p.id for p in patterns]
end

