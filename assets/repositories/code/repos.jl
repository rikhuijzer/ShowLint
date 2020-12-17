# This file was generated, do not modify it. # hide
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