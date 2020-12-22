"""
$(TYPEDEF)
$(TYPEDFIELDS)

where `exclude_prefixes` are prefixes of directories to exclude.

### Example
```
Repo("https://github.com", "JuliaLang/Julia", [], ["test"])
```
"""
struct Repo
    host::String
    name::String
    tags_predicates::Vector{Function}
    exclude_prefixes::Vector{String}
end

any_tag(tags) = true
default_predicate(tags) = all(t -> t != "performance-decrease", tags)
default_excludes = ["test"]

Repo(host, name; predicates=[default_predicate], exclude=default_excludes) =
    Repo(host, name, predicates, exclude)

const DEBUG = !haskey(ENV, "CI")

repositories(; debug=DEBUG) = debug ?
    [
        Repo("https://github.com", "fonsp/Pluto.jl"),
        Repo("https://github.com", "rikhuijzer/Codex.jl"),
    ] : 
    [
        Repo("https://github.com", "Evizero/UnicodePlots.jl"),
        Repo("https://github.com", "FRBNY-DSGE/SMC.jl"),
        Repo("https://github.com", "FluxML/MacroTools.jl"),
        Repo("https://github.com", "FluxML/Metalhead.jl"),
        Repo("https://github.com", "FluxML/Zygote.jl"),
        Repo("https://github.com", "GiovineItalia/Compose.jl"),
        Repo("https://github.com", "GiovineItalia/Gadfly.jl"),
        Repo("https://github.com", "JuliaCollections/AbstractTrees.jl"),
        Repo("https://github.com", "JuliaCollections/DataStructures.jl"),
        Repo("https://github.com", "JuliaCollections/FunctionalCollections.jl"),
        Repo("https://github.com", "JuliaCollections/IterTools.jl"),
        Repo("https://github.com", "JuliaCollections/LRUCache.jl"),
        Repo("https://github.com", "JuliaCollections/Memoize.jl"),
        Repo("https://github.com", "JuliaCollections/OrderedCollections.jl"),
        Repo("https://github.com", "JuliaData/CSV.jl"),
        Repo("https://github.com", "JuliaData/DataFrames.jl"),
        Repo("https://github.com", "JuliaData/DataFramesMeta.jl"),
        Repo("https://github.com", "JuliaData/Feather.jl"),
        Repo("https://github.com", "JuliaData/Tables.jl"),
        Repo("https://github.com", "JuliaData/YAML.jl"),
        Repo("https://github.com", "JuliaDatabases/MySQL.jl"),
        Repo("https://github.com", "JuliaDatabases/PostgreSQL.jl"),
        Repo("https://github.com", "JuliaDatabases/Redis.jl"),
        Repo("https://github.com", "JuliaDatabases/SQLite.jl"),
        Repo("https://github.com", "JuliaDebug/Debugger.jl"),
        Repo("https://github.com", "JuliaDebug/JuliaInterpreter.jl"),
        Repo("https://github.com", "JuliaDiff/ChainRules.jl"),
        Repo("https://github.com", "JuliaDiff/ChainRulesCore.jl"),
        Repo("https://github.com", "JuliaDiff/FiniteDiff.jl"),
        Repo("https://github.com", "JuliaDiff/FiniteDifferences.jl"),
        Repo("https://github.com", "JuliaDiff/ForwardDiff.jl"),
        Repo("https://github.com", "JuliaDiff/ReverseDiff.jl"),
        Repo("https://github.com", "JuliaDiff/SparseDiffTools.jl"),
        Repo("https://github.com", "JuliaDiff/TaylorSeries.jl"),
        Repo("https://github.com", "JuliaDocs/DocStringExtensions.jl"),
        Repo("https://github.com", "JuliaDocs/Documenter.jl"),
        Repo("https://github.com", "JuliaDynamics/Agents.jl"),
        Repo("https://github.com", "JuliaDynamics/ChaosTools.jl"),
        Repo("https://github.com", "JuliaDynamics/DrWatson.jl"),
        Repo("https://github.com", "JuliaDynamics/DynamicalBilliards.jl"),
        Repo("https://github.com", "JuliaDynamics/DynamicalSystems.jl"),
        Repo("https://github.com", "JuliaDynamics/DynamicalSystemsBase.jl"),
        Repo("https://github.com", "JuliaDynamics/Entropies.jl"),
        Repo("https://github.com", "JuliaGPU/AMDGPU.jl"),
        Repo("https://github.com", "JuliaGPU/ArrayFire.jl"),
        Repo("https://github.com", "JuliaGPU/CUDA.jl"),
        Repo("https://github.com", "JuliaGPU/OpenCL.jl"),
        Repo("https://github.com", "JuliaGaussianProcesses/AbstractGPs.jl"),
        Repo("https://github.com", "JuliaGaussianProcesses/KernelFunctions.jl"),
        Repo("https://github.com", "JuliaGraphs/GraphPlot.jl"),
        Repo("https://github.com", "JuliaGraphs/LightGraphs.jl"),
        Repo("https://github.com", "JuliaIO/EzXML.jl"),
        Repo("https://github.com", "JuliaIO/Formatting.jl"),
        Repo("https://github.com", "JuliaIO/HDF5.jl"),
        Repo("https://github.com", "JuliaIO/JLD.jl"),
        Repo("https://github.com", "JuliaIO/MAT.jl"),
        Repo("https://github.com", "JuliaIO/VideoIO.jl"),
        Repo("https://github.com", "JuliaImages/ImageView.jl"),
        Repo("https://github.com", "JuliaImages/Images.jl"),
        Repo("https://github.com", "JuliaInterop/Clang.jl"),
        Repo("https://github.com", "JuliaInterop/Cxx.jl"),
        Repo("https://github.com", "JuliaInterop/MATLAB.jl"),
        Repo("https://github.com", "JuliaInterop/RCall.jl"),
        Repo("https://github.com", "JuliaInterop/ZMQ.jl"),
        Repo("https://github.com", "JuliaLang/Compat.jl"),
        Repo("https://github.com", "JuliaLang/Downloads.jl"),
        Repo("https://github.com", "JuliaLang/IJulia.jl"),
        Repo("https://github.com", "JuliaLang/MbedTLS.jl"),
        Repo("https://github.com", "JuliaLang/PackageCompiler.jl"),
        Repo("https://github.com", "JuliaLang/Pkg.jl"),
        Repo("https://github.com", "JuliaLang/PkgDev.jl"),
        Repo("https://github.com", "JuliaLang/Statistics.jl"),
        Repo("https://github.com", "JuliaLang/TOML.jl"),
        Repo("https://github.com", "JuliaLang/Tokenize.jl"),
        Repo("https://github.com", "JuliaLang/julia"),
        Repo("https://github.com", "JuliaML/LossFunctions.jl"),
        Repo("https://github.com", "JuliaML/MLDataUtils.jl"),
        Repo("https://github.com", "JuliaML/MLLabelUtils.jl"),
        Repo("https://github.com", "JuliaML/Reinforce.jl"),
        Repo("https://github.com", "JuliaMath/Calculus.jl"),
        Repo("https://github.com", "JuliaMath/Combinatorics.jl"),
        Repo("https://github.com", "JuliaMath/DoubleFloats.jl"),
        Repo("https://github.com", "JuliaMath/FFTW.jl"),
        Repo("https://github.com", "JuliaMath/FixedPointNumbers.jl"),
        Repo("https://github.com", "JuliaMath/HCubature.jl"),
        Repo("https://github.com", "JuliaMath/Interpolations.jl"),
        Repo("https://github.com", "JuliaMath/Polynomials.jl"),
        Repo("https://github.com", "JuliaMath/Roots.jl"),
        Repo("https://github.com", "JuliaMath/SpecialFunctions.jl"),
        Repo("https://github.com", "JuliaNLSolvers/LsqFit.jl"),
        Repo("https://github.com", "JuliaNLSolvers/NLsolve.jl"),
        Repo("https://github.com", "JuliaNLSolvers/Optim.jl"),
        Repo("https://github.com", "JuliaPlots/Makie.jl"),
        Repo("https://github.com", "JuliaPlots/Plots.jl"),
        Repo("https://github.com", "JuliaPy/Pandas.jl"),
        Repo("https://github.com", "JuliaPy/PyCall.jl"),
        Repo("https://github.com", "JuliaPy/PyPlot.jl"),
        Repo("https://github.com", "JuliaRegistries/CompatHelper.jl"),
        Repo("https://github.com", "JuliaRegistries/Registrator.jl"),
        Repo("https://github.com", "JuliaRegistries/TagBot.jl"),
        Repo("https://github.com", "JuliaStats/Distributions.jl"),
        Repo("https://github.com", "JuliaStats/GLM.jl"),
        Repo("https://github.com", "JuliaStats/HypothesisTests.jl"),
        Repo("https://github.com", "JuliaStats/Lasso.jl"),
        Repo("https://github.com", "JuliaStats/MixedModels.jl"),
        Repo("https://github.com", "JuliaStats/StatsBase.jl"),
        Repo("https://github.com", "JuliaStats/StatsModels.jl"),
        Repo("https://github.com", "JuliaWeb/HTTP.jl"),
        Repo("https://github.com", "JuliaWeb/WebSockets.jl"),
        Repo("https://github.com", "JunoLab/Weave.jl"),
        Repo("https://github.com", "SciML/DifferentialEquations.jl"),
        Repo("https://github.com", "TuringLang/AdvancedHMC.jl"),
        Repo("https://github.com", "TuringLang/Bijectors.jl"),
        Repo("https://github.com", "TuringLang/MCMCChains.jl"),
        Repo("https://github.com", "TuringLang/Turing.jl"),
        Repo("https://github.com", "Wikunia/ConstraintSolver.jl"),
        Repo("https://github.com", "Wikunia/Javis.jl"),
        Repo("https://github.com", "alan-turing-institute/MLJ.jl"),
        Repo("https://github.com", "alan-turing-institute/MLJBase.jl"),
        Repo("https://github.com", "alan-turing-institute/MLJModels.jl"),
        Repo("https://github.com", "alan-turing-institute/MLJTuning.jl"),
        Repo("https://github.com", "bcbi/PredictMD.jl"),
        Repo("https://github.com", "bcbi/SimpleContainerGenerator.jl"),
        Repo("https://github.com", "cstjean/ScikitLearn.jl"),
        Repo("https://github.com", "denizyuret/AutoGrad.jl"),
        Repo("https://github.com", "diegozea/MIToS.jl"),
        Repo("https://github.com", "domluna/JuliaFormatter.jl"),
        Repo("https://github.com", "fonsp/Pluto.jl"),
        Repo("https://github.com", "fonsp/PlutoUI.jl"),
        Repo("https://github.com", "fonsp/PlutoUtils.jl"),
        Repo("https://github.com", "h-Klok/StatsWithJuliaBook"),
        Repo("https://github.com", "joshday/OnlineStats.jl"),
        Repo("https://github.com", "jrevels/Cassette.jl"),
        Repo("https://github.com", "julia-actions/MassInstallAction.jl"),
        Repo("https://github.com", "jump-dev/JuMP.jl"),
        Repo("https://github.com", "odow/SDDP.jl"),
        Repo("https://github.com", "queryverse/Query.jl"),
        Repo("https://github.com", "rikhuijzer/Codex.jl"),
        Repo("https://github.com", "rikhuijzer/ShowLint"),
        Repo("https://github.com", "timholy/ProfileView.jl"),
        Repo("https://github.com", "timholy/ProgressMeter.jl"),
        Repo("https://github.com", "timholy/Rebugger.jl"),
        Repo("https://github.com", "timholy/Revise.jl"),
        Repo("https://github.com", "timholy/SnoopCompile.jl"),
        Repo("https://github.com", "tlienart/Franklin.jl"),
        Repo("https://github.com", "tlienart/FranklinTemplates.jl"),
    ]

function repository_ordering_is_valid()::Bool
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
