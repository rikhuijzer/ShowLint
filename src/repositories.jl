struct Repo
    host::String
    name::String
    tags_predicates::Vector{Function}
end

any_tag(tags) = true
default(tags) = !any(t -> t == "test" || 
    t == "performance-decrease", tags)

const DEBUG = !haskey(ENV, "CI")

repositories(; debug=DEBUG) = debug ?
    [
        Repo("https://github.com", "fonsp/Pluto.jl", [default]),
        Repo("https://github.com", "rikhuijzer/Codex.jl", [default])
    ] : 
    [
        Repo("https://github.com", "Evizero/UnicodePlots.jl", [default]),
        Repo("https://github.com", "FRBNY-DSGE/SMC.jl", [default]),
        Repo("https://github.com", "FluxML/MacroTools.jl", [default]),
        Repo("https://github.com", "FluxML/Metalhead.jl", [default]),
        Repo("https://github.com", "FluxML/Zygote.jl", [default]),
        Repo("https://github.com", "GiovineItalia/Compose.jl", [default]),
        Repo("https://github.com", "GiovineItalia/Gadfly.jl", [default]),
        Repo("https://github.com", "JuliaCollections/AbstractTrees.jl", [default]),
        Repo("https://github.com", "JuliaCollections/DataStructures.jl", [default]),
        Repo("https://github.com", "JuliaCollections/FunctionalCollections.jl", [default]),
        Repo("https://github.com", "JuliaCollections/IterTools.jl", [default]),
        Repo("https://github.com", "JuliaCollections/LRUCache.jl", [default]),
        Repo("https://github.com", "JuliaCollections/Memoize.jl", [default]),
        Repo("https://github.com", "JuliaCollections/OrderedCollections.jl", [default]),
        Repo("https://github.com", "JuliaData/CSV.jl", [default]),
        Repo("https://github.com", "JuliaData/DataFrames.jl", [default]),
        Repo("https://github.com", "JuliaData/DataFramesMeta.jl", [default]),
        Repo("https://github.com", "JuliaData/Feather.jl", [default]),
        Repo("https://github.com", "JuliaData/Tables.jl", [default]),
        Repo("https://github.com", "JuliaData/YAML.jl", [default]),
        Repo("https://github.com", "JuliaDatabases/MySQL.jl", [default]),
        Repo("https://github.com", "JuliaDatabases/PostgreSQL.jl", [default]),
        Repo("https://github.com", "JuliaDatabases/Redis.jl", [default]),
        Repo("https://github.com", "JuliaDatabases/SQLite.jl", [default]),
        Repo("https://github.com", "JuliaDebug/Debugger.jl", [default]),
        Repo("https://github.com", "JuliaDebug/JuliaInterpreter.jl", [default]),
        Repo("https://github.com", "JuliaDiff/ChainRules.jl", [default]),
        Repo("https://github.com", "JuliaDiff/ChainRulesCore.jl", [default]),
        Repo("https://github.com", "JuliaDiff/FiniteDiff.jl", [default]),
        Repo("https://github.com", "JuliaDiff/FiniteDifferences.jl", [default]),
        Repo("https://github.com", "JuliaDiff/ForwardDiff.jl", [default]),
        Repo("https://github.com", "JuliaDiff/ReverseDiff.jl", [default]),
        Repo("https://github.com", "JuliaDiff/SparseDiffTools.jl", [default]),
        Repo("https://github.com", "JuliaDiff/TaylorSeries.jl", [default]),
        Repo("https://github.com", "JuliaDocs/DocStringExtensions.jl", [default]),
        Repo("https://github.com", "JuliaDocs/Documenter.jl", [default]),
        Repo("https://github.com", "JuliaDynamics/Agents.jl", [default]),
        Repo("https://github.com", "JuliaDynamics/ChaosTools.jl", [default]),
        Repo("https://github.com", "JuliaDynamics/DrWatson.jl", [default]),
        Repo("https://github.com", "JuliaDynamics/DynamicalBilliards.jl", [default]),
        Repo("https://github.com", "JuliaDynamics/DynamicalSystems.jl", [default]),
        Repo("https://github.com", "JuliaDynamics/DynamicalSystemsBase.jl", [default]),
        Repo("https://github.com", "JuliaDynamics/Entropies.jl", [default]),
        Repo("https://github.com", "JuliaGPU/AMDGPU.jl", [default]),
        Repo("https://github.com", "JuliaGPU/ArrayFire.jl", [default]),
        Repo("https://github.com", "JuliaGPU/CUDA.jl", [default]),
        Repo("https://github.com", "JuliaGPU/OpenCL.jl", [default]),
        Repo("https://github.com", "JuliaGaussianProcesses/AbstractGPs.jl", [default]),
        Repo("https://github.com", "JuliaGaussianProcesses/KernelFunctions.jl", [default]),
        Repo("https://github.com", "JuliaGraphs/GraphPlot.jl", [default]),
        Repo("https://github.com", "JuliaGraphs/LightGraphs.jl", [default]),
        Repo("https://github.com", "JuliaIO/EzXML.jl", [default]),
        Repo("https://github.com", "JuliaIO/Formatting.jl", [default]),
        Repo("https://github.com", "JuliaIO/HDF5.jl", [default]),
        Repo("https://github.com", "JuliaIO/JLD.jl", [default]),
        Repo("https://github.com", "JuliaIO/MAT.jl", [default]),
        Repo("https://github.com", "JuliaIO/VideoIO.jl", [default]),
        Repo("https://github.com", "JuliaImages/ImageView.jl", [default]),
        Repo("https://github.com", "JuliaImages/Images.jl", [default]),
        Repo("https://github.com", "JuliaInterop/Clang.jl", [default]),
        Repo("https://github.com", "JuliaInterop/Cxx.jl", [default]),
        Repo("https://github.com", "JuliaInterop/MATLAB.jl", [default]),
        Repo("https://github.com", "JuliaInterop/RCall.jl", [default]),
        Repo("https://github.com", "JuliaInterop/ZMQ.jl", [default]),
        Repo("https://github.com", "JuliaLang/Compat.jl", [default]),
        Repo("https://github.com", "JuliaLang/Downloads.jl", [default]),
        Repo("https://github.com", "JuliaLang/IJulia.jl", [default]),
        Repo("https://github.com", "JuliaLang/MbedTLS.jl", [default]),
        Repo("https://github.com", "JuliaLang/PackageCompiler.jl", [default]),
        Repo("https://github.com", "JuliaLang/Pkg.jl", [default]),
        Repo("https://github.com", "JuliaLang/PkgDev.jl", [default]),
        Repo("https://github.com", "JuliaLang/Statistics.jl", [default]),
        Repo("https://github.com", "JuliaLang/TOML.jl", [default]),
        Repo("https://github.com", "JuliaLang/Tokenize.jl", [default]),
        Repo("https://github.com", "JuliaLang/julia", [default]),
        Repo("https://github.com", "JuliaML/LossFunctions.jl", [default]),
        Repo("https://github.com", "JuliaML/MLDataUtils.jl", [default]),
        Repo("https://github.com", "JuliaML/MLLabelUtils.jl", [default]),
        Repo("https://github.com", "JuliaML/Reinforce.jl", [default]),
        Repo("https://github.com", "JuliaNLSolvers/LsqFit.jl", [default]),
        Repo("https://github.com", "JuliaNLSolvers/NLsolve.jl", [default]),
        Repo("https://github.com", "JuliaNLSolvers/Optim.jl", [default]),
        Repo("https://github.com", "JuliaPlots/Makie.jl", [default]),
        Repo("https://github.com", "JuliaPlots/Plots.jl", [default]),
        Repo("https://github.com", "JuliaPy/Pandas.jl", [default]),
        Repo("https://github.com", "JuliaPy/PyCall.jl", [default]),
        Repo("https://github.com", "JuliaPy/PyPlot.jl", [default]),
        Repo("https://github.com", "JuliaStats/Distributions.jl", [default]),
        Repo("https://github.com", "JuliaStats/GLM.jl", [default]),
        Repo("https://github.com", "JuliaStats/HypothesisTests.jl", [default]),
        Repo("https://github.com", "JuliaStats/Lasso.jl", [default]),
        Repo("https://github.com", "JuliaStats/MixedModels.jl", [default]),
        Repo("https://github.com", "JuliaStats/StatsBase.jl", [default]),
        Repo("https://github.com", "JuliaStats/StatsModels.jl", [default]),
        Repo("https://github.com", "JuliaWeb/HTTP.jl", [default]),
        Repo("https://github.com", "JuliaWeb/WebSockets.jl", [default]),
        Repo("https://github.com", "JunoLab/Weave.jl", [default]),
        Repo("https://github.com", "SciML/DifferentialEquations.jl", [default]),
        Repo("https://github.com", "TuringLang/AdvancedHMC.jl", [default]),
        Repo("https://github.com", "TuringLang/Bijectors.jl", [default]),
        Repo("https://github.com", "TuringLang/MCMCChains.jl", [default]),
        Repo("https://github.com", "TuringLang/Turing.jl", [default]),
        Repo("https://github.com", "Wikunia/ConstraintSolver.jl", [default]),
        Repo("https://github.com", "Wikunia/Javis.jl", [default]),
        Repo("https://github.com", "alan-turing-institute/MLJ.jl", [default]),
        Repo("https://github.com", "alan-turing-institute/MLJBase.jl", [default]),
        Repo("https://github.com", "alan-turing-institute/MLJModels.jl", [default]),
        Repo("https://github.com", "alan-turing-institute/MLJTuning.jl", [default]),
        Repo("https://github.com", "cstjean/ScikitLearn.jl", [default]),
        Repo("https://github.com", "denizyuret/AutoGrad.jl", [default]),
        Repo("https://github.com", "fonsp/Pluto.jl", [default]),
        Repo("https://github.com", "fonsp/PlutoUI.jl", [default]),
        Repo("https://github.com", "fonsp/PlutoUtils.jl", [default]),
        Repo("https://github.com", "h-Klok/StatsWithJuliaBook", [default]),
        Repo("https://github.com", "joshday/OnlineStats.jl", [default]),
        Repo("https://github.com", "jrevels/Cassette.jl", [default]),
        Repo("https://github.com", "jump-dev/JuMP.jl", [default]),
        Repo("https://github.com", "odow/SDDP.jl", [default]),
        Repo("https://github.com", "queryverse/Query.jl", [default]),
        Repo("https://github.com", "rikhuijzer/Codex.jl", [default]),
        Repo("https://github.com", "rikhuijzer/ShowLint", [default]),
        Repo("https://github.com", "timholy/ProfileView.jl", [default]),
        Repo("https://github.com", "timholy/ProgressMeter.jl", [default]),
        Repo("https://github.com", "timholy/Rebugger.jl", [default]),
        Repo("https://github.com", "timholy/Revise.jl", [default]),
        Repo("https://github.com", "timholy/SnoopCompile.jl", [default]),
        Repo("https://github.com", "tlienart/Franklin.jl", [default]),
        Repo("https://github.com", "tlienart/FranklinTemplates.jl", [default]),
    ]

function valid_repository_names()::Bool
    names = [r.name for r in repositories(; debug=false)]
    sorted = Base.sort(names)
    unique_and_sorted = unique(sorted)
    ok = names == unique_and_sorted
    if !ok
        if length(names) != length(unique_and_sorted)
            error("repositories contains at least one duplicate")
        end
        for (actual, expected) in zip(names, unique_and_sorted)
            if actual != expected
                error("Repositories not ordered, expected: $expected, got: $actual")
            end
        end
    end
    ok
end
