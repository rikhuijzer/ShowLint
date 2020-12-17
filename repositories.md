+++
title = "Repositories"
reeval = true
+++

# Repositories

The repositories listed below are defined in `repositories.csv`.

```julia:repos
# hideall
using ShowLint

for repo in repositories
  diff = ShowLint.apply("p2", repo)
  println("""
    ~~~
    <h3>$(repo.name)</h3>
    p2.toml
    ~~~
    $diff
  """)
end
```
\textoutput{repos}
