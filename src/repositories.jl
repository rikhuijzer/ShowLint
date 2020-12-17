struct Repo
    host::String
    name::String
    tags_predicate::Function
end

any_tag(tags) = true
not_test(tags) = !any(tag -> tag == "test", tags)

repositories = [
    Repo("https://github.com", "JuliaLang/julia", not_test),
    # Repo("https://github.com", "rikhuijzer/Codex.jl", any_tag),
    # Repo("https://github.com", "JuliaData/CSV.jl", not_test)
]
