# This file was generated, do not modify it. # hide
# hideall
using ShowLint

dir = joinpath(project_root, patterns_dir)

pattern_files = readdir(dir)

for file in pattern_files
  content = read(joinpath(dir, file), String)
  println("""
  ~~~ 
  <h3>$file</h3>
  <pre><code class="plaintext hljs">$content</code></pre>
  ~~~
  """)
end