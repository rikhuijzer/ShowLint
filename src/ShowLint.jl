module ShowLint

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
    "0;34" => "blue",
    "0;1" => "inherit",
    "0;100;30" => "inherit",
    "0;41;30" => "red",
    "0;42;30" => "green",
    "0;2" => "gray"
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
  text = replace(text, "/repo/" => "")
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

const clones_dir = joinpath(homedir(), "clones") 

function clone_repositories()
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

"""
    apply(pattern, repository)

Apply `pattern` to `repository`.

### Examples
```
apply("p1", "JuliaData/CSV.jl")
```
"""
function apply(pattern, repository; file_extensions="jl")::String
    configs_dir = "configs"
    configs_path = joinpath(project_root, "configs")
    configs_volume = "$configs_path:/configs"
    repo_path = joinpath(clones_dir, repository)
    repo_volume = "$repo_path:/repo"

    config_flag = "-config /configs/$pattern.toml"
    directory_flag = "-directory /repo" 
    comby_flags = "$config_flag $directory_flag -f $file_extensions"

    # Not pretty, but it works.
    cmd = `podman run
        --volume $configs_path:/configs
        --volume $repo_path:/repo
        --rm
        -it comby/comby
        -config /configs/$pattern.toml
        -directory /repo
        -file-extensions $file_extensions
        `
    stdout = IOBuffer()
    run(pipeline(cmd; stdout))
    out = String(take!(stdout))
    out = ansi2html(out)
end

end # module
