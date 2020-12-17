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
  println("### $(repo.name)")

  for pat in patterns
    diff = ShowLint.apply(pat, repo)
    descr = pat.description
    id = pat.id
    println("""
      $id: [$descr](/patterns/#$id)
      $diff
    """)
  end
end
```
\textoutput{repos}
