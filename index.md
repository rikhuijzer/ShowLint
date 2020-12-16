+++
title = "ShowLint"
tags = ["syntax"]
reeval = true
+++

# ShowLint

```julia:preliminaries
# hideall
using DisplayLint
```

This website shows linting results for [patterns](/patterns) on [repositories](/repositories) by using [Comby](https://github.com/comby-tools/comby).
As an example, lets run the pattern `p1` on this repository.
The pattern finds toml files containing `name = "..."` and adds a comment before that line:

```julia:pattern
# hideall
p1_file = joinpath(project_root, "configs", "p1.toml")
println(read(p1_file, String))
```
\output{pattern}

The output is

```julia:first
# hideall

# first_config = joinpath(project_root(), "configs", "one.toml")
cmd = `comby -config configs/p1.toml -f toml`
stdout = IOBuffer()
run(pipeline(cmd; stdout))
out = String(take!(stdout))
# println(out)
out = ansi2html(out)
println(out)
```
\textoutput{first}
