+++
title = "ShowLint"
tags = ["syntax", "lint"]
reeval = true
+++

# ShowLint

Linters have obvious benefits but, like any tool, can be hard to use.
Not all users have the time to install and update a linter, and inspect its output.
Also, some linters show many false-positives and cause the code to be littered with `ignore ...` comments, and any suggestion by the linter is only interesting once.
After a decision is made on applying the suggestion, the suggestion should not come back.

So, I figured that it might be useful to periodically generate the lint results for many repositories and show the results on a website.

This website shows linting results for

```julia:insert-numbers
# hideall
using ShowLint; SL = ShowLint
n_patterns = length(SL.patterns)
n_repositories = length(SL.repositories())
n_loc = SL.cloned_loc()
pretty_n_loc = SL.prettify_loc(n_loc)
n_loc_text = "(about $pretty_n_loc lines of code)"

println("""
- [$n_patterns patterns](/patterns) on 
- [$n_repositories repositories](/repositories) $n_loc_text.
""")
```
\textoutput{insert-numbers}

If the linter shows useful rewrites, then consider making a pull request.
For many changes, use Comby.
All the required information to apply Comby available on this website and in Comby's documentation.
To automate pull request creation, see [Sourcegraph Campaigns](https://sourcegraph.com/campaigns).

The source code of this website is at <https://github.com/rikhuijzer/ShowLint>.

## List of merged refactors 

These small refactors have been detected via this site and are merged:

1. <https://github.com/JuliaLang/Pkg.jl/pull/2297>
1. <https://github.com/JuliaData/YAML.jl/pull/103>
1. <https://github.com/JuliaDynamics/Agents.jl/pull/357>
1. <https://github.com/JuliaPlots/Plots.jl/pull/3200>
1. <https://github.com/StatisticalRethinkingJulia/StatisticalRethinking.jl/pull/104>

For stale and closed PRs, see [notes](/notes).
