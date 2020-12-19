+++
title = "Repositories"
reeval = true
+++

# Repositories

The repositories listed below are defined in `repositories.csv`.

```julia:create_repo_pages
using Franklin

# hideall
using ShowLint
SL = ShowLint

pages_headers = SL.PAGES_HEADERS 
```

```julia:repos
# hideall
using ShowLint
SL = ShowLint

for (repo, headers) in zip(repositories, pages_headers)
  path = SL.page_path(repo)
  url = "/" * first(splitext(path))
  link_text = repo.name

  function sublink(header)
    ref_str = Franklin.refstring(header)
    "- [$header]($url/#$ref_str)" 
  end
  sublinks = sublink.(headers)
  sublinks_text = join(sublinks, '\n')

  println(
    """
    ### $link_text
    ~~~
    <div class="repo-nav">
    <span> source: $(SL.host_dir(repo)) <br/></span>
    ~~~
    $sublinks_text
    ~~~
    </div>
    ~~~
    """
  )
end
```
\textoutput{repos}
