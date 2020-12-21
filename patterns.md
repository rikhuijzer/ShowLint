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
Some suggested rewrites will be inappropriate (false-positive).
This is unavoidable because, for example, these rewrite rules don't take context into account.
Nonetheless, a lot of the rewrites suggested here are appropriate.
Use `comby -review` to **interactively review** and filter out the false-positives.

The tags below can be used to filter out patterns.
For example, suppose a repository wants to be compatible with Julia `≥1.0`.
Then, rewrite suggestions which only hold for Julia `≥1.2` should be hidden.

Some of these patterns could be simplified by improving Comby's language definition for Julia.
For now, I have sticked to the existing language defintion.

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
  ~~~
  <pre><code class="plaintext">$toml</code></pre>
  ~~~

  $descr
  """)
end
```

\textoutput{patterns}

