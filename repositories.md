+++
title = "Repositories"
+++

# Repositories

The repositories listed below are defined in `repositories.csv`.

[julia](/github/julialang/julia)

\toc 

```julia:repos
# hideall
using ShowLint

for repo in repositories
  predicates_str = join(repo.tags_predicates, " && ")
  println("""
    ### $(repo.name)
    Showing patterns for which the `tags` satisfy: *$predicates_str*

    """
  )

  predicates = repo.tags_predicates
  all_predicates_hold(tags) = all([p(tags) for p in predicates])
  filtered_patterns = filter(pat -> all_predicates_hold(pat.tags), patterns)

  for pat in filtered_patterns
    diff = ShowLint.apply(pat, repo)
    title = pat.title
    id = pat.id
    println("""
      $id: [$title](/patterns/#$id)
      $diff
    """)
  end
end
```
\textoutput{repos}
