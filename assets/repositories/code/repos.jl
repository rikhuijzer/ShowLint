# This file was generated, do not modify it. # hide
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