module DisplayLint

using DataFrames

import CSV

export project_root,
    ansi2html,
    repositories,
    clone_repositories

const project_root = pwd()

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
  text = replace(text, r"WARNING: [^\n]*$" => "")
  text = replace(text, "/pwd/" => "")
  text = text[1:end-6]
  text = strip(text)
  """
  ~~~ 
  <pre>
  <div class="hljs">$text</div>
  </pre>
  ~~~
  """
end

function repositories()
    repositories_file = joinpath(project_root, "repositories.csv")
    df = CSV.read(repositories_file, DataFrame)
    string.(df[:, :name])
end

function clone_repositories()
    clones_dir = joinpath(homedir(), "clones") 
    if !isdir(clones_dir)
        mkdir(clones_dir)
    end
    for name in repositories()
        target_dir = joinpath(clones_dir, name) 
        if isdir(target_dir)
            rm(target_dir; recursive=true, force=true)
        end
        run(`git clone https://github.com/$name $target_dir`)
    end
end

end # module
