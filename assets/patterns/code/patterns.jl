# This file was generated, do not modify it. # hide
# hideall
using ShowLint

for pattern in patterns
  id = pattern.id
  descr = pattern.description
  tags = join(pattern.tags, ", ")
  toml = pattern.toml
  println("""
  ~~~ 
  <h3 id="$id">$id: $descr</h3>
  tags: <i>$tags</i> <br/>
  <pre><code class="plaintext">$toml</code></pre>
  ~~~
  """)
end