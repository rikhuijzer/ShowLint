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

\toc 

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
```

\textoutput{patterns}

### References
\biblabel{pTonder2016}{van Tonder & Le Goues, 2016}
van Tonder, R., & Le Goues, C. (2016, May). 
Defending against the attack of the micro-clones. 
In 2016 IEEE 24th International Conference on Program Comprehension (ICPC) (pp. 1-4). 
IEEE.
<https://doi.org/10.1109/ICPC.2016.7503736>.
