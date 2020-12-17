# This file was generated, do not modify it. # hide
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