module ShowLint

using DataFrames

import CSV

export 
    Pattern,
    Repo,
    project_root,
    ansi2html,
    clone_repositories,
    target_dir,
    patterns,
    repositories

include("patterns.jl")
include("repositories.jl")

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

const clones_dir = joinpath(homedir(), "clones") 

function host_dir(repo::Repo)
    host = repo.host
    host_dir = startswith(host, "https://") ? host[9:end] : host
    host_dir = lowercase(host_dir) == "github.com" ? "github" : host_dir
end

function target_dir(repo::Repo)
    name = repo.name
    joinpath(clones_dir, host_dir(repo), name) 
end

function clone_repositories()
    if !isdir(clones_dir)
        mkdir(clones_dir)
    end
    for repo in repositories
        name = repo.name
        host = repo.host
        dest = target_dir(repo)
        if isdir(dest)
            rm(dest; recursive=true, force=true)
        end
        run(`git clone $host/$name $dest`)
        println()
    end
end

function create_config(pat::Pattern, dir)::String
    id = pat.id
    toml = pat.toml
    name = "p$id"
    text = """
        [$name] 

        $toml
        """
    if isdir(dir)
        foreach(name -> rm(name; recursive=true, force=true), readdir(dir))
    else
        mkdir(dir)
    end
    file = joinpath(dir, "$name.toml")
    open(file, "w") do io
        write(io, text)
    end
    name
end

"""
    apply(pat::Pattern, repo::Repo; file_extensions="jl")::String

Apply `pattern` to `repo`.

### Examples
```
repo = Repo("https://github.com", "JuliaData/CSV.jl")
apply("p1", repo)
```
"""
function apply(pat::Pattern, repo::Repo; file_extensions="jl")::String
    configs_dir = "configs"
    configs_path = joinpath(project_root, "configs")
    repo_path = target_dir(repo)

    name = create_config(pat, configs_path)

    # Not pretty, but it works.
    cmd = `podman run
        --volume $configs_path:/configs
        --volume $repo_path:/repo
        --rm
        -it comby/comby
        -config /configs/$name.toml
        -directory /repo
        -file-extensions $file_extensions
        `
    stdout = IOBuffer()
    run(pipeline(cmd; stdout))
    out = String(take!(stdout))
    function avoid_franklin_parse_errors(out)
        out = replace(out, '`' => "&#96;")
        out = replace(out, '"' => "&#34;")
    end
    out = avoid_franklin_parse_errors(out)
    out = ansi2html(out)
end

"""
    create_repo_pages()

Create one webpage per repository.
This step should happen before `serve()` is called.
"""
function create_repo_pages()
    for repo in repositories
        if !isdir(host_dir(repo))
            mkdir(host_dir(repo))
        end
        name = repo.name
        franklin_file = lowercase(joinpath(host_dir(repo), "$name.md"))
        if !isdir(dirname(franklin_file))
            mkdir(dirname(franklin_file))
        end
        open(franklin_file, "w") do io
            write(io, """
                +++
                title = "$(repo.name)"
                +++

                lorem
                """
            )
        end
    end
end

end # module
