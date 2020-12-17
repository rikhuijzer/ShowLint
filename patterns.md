+++
title = "Patterns"
date = Date(2019, 3, 22)
tags = ["syntax", "code"]
reeval = true
+++

# Patterns

```julia:preliminaries
# hideall
patterns_dir = "configs"
```

This page lists the patterns defined in `configs/`.

```julia:patterns
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
```

\textoutput{patterns}

