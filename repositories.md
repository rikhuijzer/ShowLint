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
S = ShowLint

for repo in repositories
  path = S.page_path(repo)
  url = "/" * first(splitext(path))
  link_text = repo.name
  println(
    """
    ~~~
    <p>
    <a href="$url">$link_text</a> <br/>
    $(S.host_dir(repo)) <br/>
    </p>
    ~~~
    """
  )
end
```
\textoutput{repos}
