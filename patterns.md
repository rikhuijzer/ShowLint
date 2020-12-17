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

This page lists the patterns as defined in `src/patterns.jl`.

```julia:patterns
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
```

\textoutput{patterns}

