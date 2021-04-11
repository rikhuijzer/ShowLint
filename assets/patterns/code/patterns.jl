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
  <span id="$id"></span>
  ~~~
  ### $id: $title
  tags: *$tags*

  $descr

  ~~~
  <b>Defintion</b>
  <pre><code class="plaintext">$toml</code></pre>
  ~~~
  """)
end