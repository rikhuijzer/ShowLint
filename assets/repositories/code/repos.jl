# This file was generated, do not modify it. # hide
# hideall
using ShowLint

for repo in repositories()
  diff = ShowLint.apply("p2", repo)
  println("""
    ~~~
    <h3>$repo</h3>
    p2.toml
    ~~~
    $diff
  """)
end