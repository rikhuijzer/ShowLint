+++
title = "Repositories"
reeval = true
+++

# Repositories

The repositories listed below are defined in `repositories.csv`.

~~~
<div class="repositories-list">
~~~
```julia:create_repo_pages
using Franklin

# hideall
using ShowLint
SL = ShowLint
using Serialization

headers_path = joinpath(SL.project_root, "__site", "pages-headers.txt")
pages_headers = Serialization.deserialize(headers_path)
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

  source_text = "source" # SL.host_dir(repo)
  source_link = joinpath(repo.host, repo.name)

  println(
    """
    ### $link_text
    ~~~
    <div class="repo-nav">
    <span> <i><a href="$source_link">$source_text</a></i> <br/></span>
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
~~~
</div>
~~~
