+++
title = "Repositories"
reeval = true
+++

# Repositories

Please note that this list is not meant as a way of showing which repository contains the most "mistakes".
The goal is to aid busy package developers in avoiding bugs and keeping the packages up-to-date.

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
pages_headers = isfile(headers_path) ?
  Serialization.deserialize(headers_path) :
  []
```

```julia:repos
# hideall
using ShowLint
SL = ShowLint

for (repo, headers) in zip(repositories(), pages_headers)
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
    ~~~
    <h3><a href="$source_link" target="_blank">$link_text</a></h3>
    <div class="repo-nav">
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
