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

These patterns use [Comby](https://comby.dev) for "searching and changing code structure".
Comby allows us to express rewrite rules succinctly.
Some rewrite suggestions will be inappropriate (false-positive).
This is unavoidable because these rewrite rules don't take context into account.
Still, a lot of the rewrites suggested here are appropriate.
To **interactively review** changes before applying them, use `comby -review`.

```julia:patterns
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

  $descr
  ~~~
  <pre><code class="plaintext">$toml</code></pre>
  ~~~
  """)
end
```

\textoutput{patterns}

