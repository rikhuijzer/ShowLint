# This file was generated, do not modify it. # hide
# hideall
using ShowLint

for pattern in patterns
  id = pattern.id
  title = pattern.title
  descr = pattern.description
  tags = join(pattern.tags, ", ")
  toml = pattern.toml
  println("""
  
  ~~~ 
  <h3 id="$id">$id: $title</h3>
  ~~~
  tags: *$tags*
  ~~~
  <pre><code class="plaintext">$toml</code></pre>
  ~~~

  $descr
  """)
end