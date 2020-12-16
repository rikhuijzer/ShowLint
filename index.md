+++
title = "Display lint"
tags = ["syntax"]
reeval = true
+++

# Display lint

```julia:preliminaries
# hideall
using DisplayLint
project_root()::String = basename(basename(pathof(DisplayLint)))

function ansi2html(text)
  escape_codes = Dict(
    "0;30" => "inherit",
    "0;31" => "red",
    "0;32" => "green",
    "0;33" => "brown",
    "0;34" => "blue",
    "0;1" => "inherit",
    "0;100;30" => "inherit",
    "0;42;30" => "green",
    # "0;1" => "black"
  )
  for code in keys(escape_codes)
    before = "[" * code * "m"
    color = escape_codes[code]
    after = "<span style=\"color:$color;\">"
    text = replace(text, before => after)
  end
  no_color = "[0m"
  text = replace(text, no_color => "</span>")
  """
  ~~~ 
  <pre>
  <div class="hljs">
  $text 
  </div>
  </pre>
  ~~~
  """
end
```

```julia:first
# first_config = joinpath(project_root(), "configs", "one.toml")
cmd = `comby -config configs/one.toml -f toml`
stdout = IOBuffer()
run(pipeline(cmd; stdout))
out = String(take!(stdout))
# println(out)
out = ansi2html(out)
println(out)
```

\textoutput{first}
