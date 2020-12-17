+++
title = "Repositories"
reeval = true
+++

# Repositories

The repositories listed below are defined in `repositories.csv`.

\toc 

```julia:repos
# hideall
using ShowLint

for repo in repositories
  println("""
    ### $(repo.name)
    ~~~
    Showing patterns for which the <code>tags</code> satisfy: 
    <code>$(repo.tags_predicate)</code>
    <br/>
    <br/>
    ~~~
    """
  )

  predicate = repo.tags_predicate
  filtered_patterns = filter(p -> predicate(p.tags), patterns)

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
