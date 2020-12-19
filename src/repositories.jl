struct Repo
    host::String
    name::String
    tags_predicates::Vector{Function}
end

any_tag(tags) = true
default(tags) = !any(tag -> tag == "test", tags)

debug = !haskey(ENV, "CI")

repositories = debug ?
    [
        Repo("https://github.com", "fonsp/Pluto.jl", [default]),
        Repo("https://github.com", "rikhuijzer/Codex.jl", [default])
    ] : 
    [
        Repo("https://github.com", "alan-turing-institute/MLJ.jl", [default]),
        Repo("https://github.com", "FluxML/MacroTools.jl", [default]),
        Repo("https://github.com", "FluxML/Zygote.jl", [default]),
        Repo("https://github.com", "fonsp/Pluto.jl", [default]),
        Repo("https://github.com", "GiovineItalia/Gadfly.jl", [default]),
        Repo("https://github.com", "jrevels/Cassette.jl", [default]),
        Repo("https://github.com", "JuliaCollections/Memoize.jl", [default]),
        Repo("https://github.com", "JuliaData/CSV.jl", [default]),
        Repo("https://github.com", "JuliaData/DataFrames.jl", [default]),
        Repo("https://github.com", "JuliaData/DataFramesMeta.jl", [default]),
        Repo("https://github.com", "JuliaData/Tables.jl", [default]),
        Repo("https://github.com", "JuliaData/YAML.jl", [default]),
        Repo("https://github.com", "JuliaDatabases/Redis.jl", [default]),
        Repo("https://github.com", "JuliaDebug/Debugger.jl", [default]),
        Repo("https://github.com", "JuliaImages/Images.jl", [default]),
        Repo("https://github.com", "JuliaLang/IJulia.jl", [default]),
        Repo("https://github.com", "JuliaLang/julia", [default]),
        Repo("https://github.com", "JuliaLang/PackageCompiler.jl", [default]),
        Repo("https://github.com", "JuliaLang/Pkg.jl", [default]),
        Repo("https://github.com", "JuliaPlots/Makie.jl", [default]),
        Repo("https://github.com", "JuliaPlots/Plots.jl", [default]),
        Repo("https://github.com", "JuliaStats/Distributions.jl", [default]),
        Repo("https://github.com", "JuliaPy/PyCall.jl", [default]),
        Repo("https://github.com", "JuliaWeb/HTTP.jl", [default]),
        Repo("https://github.com", "JuliaWeb/WebSockets.jl", [default]),
        Repo("https://github.com", "jump-dev/JuMP.jl", [default]),
        Repo("https://github.com", "odow/SDDP.jl", [default]),
        Repo("https://github.com", "rikhuijzer/Codex.jl", [default]),
        Repo("https://github.com", "SciML/DifferentialEquations.jl", [default]),
        Repo("https://github.com", "timholy/Rebugger.jl", [default]),
        Repo("https://github.com", "timholy/Revise.jl", [default]),
        Repo("https://github.com", "timholy/SnoopCompile.jl", [default]),
        Repo("https://github.com", "timholy/ProgressMeter.jl", [default]),
        Repo("https://github.com", "timholy/ProfileView.jl", [default]),
        Repo("https://github.com", "tlienart/Franklin.jl", [default]),
        Repo("https://github.com", "tlienart/FranklinTemplates.jl", [default]),
        Repo("https://github.com", "Wikunia/Javis.jl", [default]),
        Repo("https://github.com", "Wikunia/ConstraintSolver.jl", [default]),
        Repo("https://github.com", "queryverse/Query.jl", [default]),
    ]
