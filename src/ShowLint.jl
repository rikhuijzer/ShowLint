module ShowLint

using Serialization

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
    "0;43;30" => "orange",
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
  text = replace(text, "" => "") 
  text = replace(text, "<!" => "&#60;!")
  text = text[1:end-6]
  text = strip(text)
  return length(text) < 6 ? 
        "" :
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

function page_path(repo::Repo)
    name = repo.name
    lowercase(joinpath(host_dir(repo), "$name.md"))
end

function clone_repositories()
    if !isdir(clones_dir)
        mkdir(clones_dir)
    end
    for repo in repositories
        println("Cloning $(repo.name)")
        name = repo.name
        host = repo.host
        dest = target_dir(repo)
        if isdir(dest)
            cd(dest)
            run(`git pull --ff-only`)
        else
            run(`git clone $host/$name $dest`)
        end
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

function number_of_matches(err)
    regex = r"\"number_of_matches\": ([0-9]*)"
    m = match(regex, err)
    n_str = m[1]
    parse(Int, n_str)
end

"""
    apply(pat::Pattern, repo::Repo; file_extensions="jl")::String

Apply `pattern` to `repo`.
```
"""
function apply(pat::Pattern, repo::Repo; 
    file_extensions="jl", in_place=false)

    configs_dir = "configs"
    configs_path = joinpath(project_root, "configs")
    repo_path = target_dir(repo)

    name = create_config(pat, configs_path)

    # Not pretty but it works.
    cmd = !in_place ? 
        `podman run
        --rm
        --volume $configs_path:/configs
        --volume $repo_path:/repo
        --entrypoint="sh"
        -it comby/comby
        -c "comby \
            -stats \
            -config /configs/$name.toml \
            -directory /repo \
            -file-extensions $file_extensions \
            2>/repo/stderr.log
        "
        ` :
        `podman run
        --rm
        --volume $configs_path:/configs
        --volume $repo_path:/repo
        -it comby/comby
        -config /configs/$name.toml
        -directory /repo
        -file-extensions $file_extensions
        -in-place
        `

    stdout = IOBuffer()
    run(pipeline(cmd; stdout))
    out = String(take!(stdout))
    err = ""
    function avoid_franklin_parse_errors(out)
        out = replace(out, '`' => "&#96;")
        out = replace(out, '"' => "&#34;")
        out
    end
    if !in_place
        out = avoid_franklin_parse_errors(out)
        if !isnothing(out)
            out = ansi2html(out)
        end
        err = read(joinpath(repo_path, "stderr.log"), String) 
    end
    return (out, err)
end

function repo_page(repo::Repo)
    predicates_str = join(repo.tags_predicates, " && ")
    headers = []
    repo_url = joinpath(repo.host, repo.name)
    head = """
        ~~~
        <h1><a href="$repo_url" target="_blank">$(repo.name)</a></h1>
        ~~~

        Showing patterns for which the `tags` satisfy:
        *$predicates_str*, and the pattern resulted in at least one match.

        \\toc

        """ 

    predicates = repo.tags_predicates
    all_predicates_hold(tags) = all([p(tags) for p in predicates])
    filtered_patterns = filter(pat -> all_predicates_hold(pat.tags), patterns)

    function pattern_section(pat)
        diff, err = ShowLint.apply(pat, repo)
        title = pat.title
        id = pat.id
        n_matches = number_of_matches(err)
        n_text = n_matches == 1 ? "hit" : "hits"
        unicode_em_space = " " 
        header = "$title$(unicode_em_space)➤$(unicode_em_space)$n_matches $n_text"

        if diff == ""
            return ""
        else
            push!(headers, header)
            return """
            ### $header
            [Pattern #$id](/patterns/#$id)

            $diff

            """
        end
    end
    sections = pattern_section.(filtered_patterns)

    return (
        headers = headers,
        text = join([head, sections...], '\n') 
    )
end

"""
    create_repo_pages()

Create one webpage per repository.
This step should happen before `serve()` is called.
We could process all the diffs when this function is called
or when `serve` runs. It seems more flexible to do it as early
as possible.
"""
function create_repo_pages()
    pages_headers = []

    for repo in repositories
        if !isdir(host_dir(repo))
            mkdir(host_dir(repo))
        end
        franklin_file = page_path(repo)
        println("Creating repository page at $franklin_file")
        if !isdir(dirname(franklin_file))
            mkdir(dirname(franklin_file))
        end

        page_headers, page_text = repo_page(repo)
        push!(pages_headers, page_headers)

        open(franklin_file, "w") do io
            write(io, """
                +++
                title = "$(repo.name)"
                +++

                [//]: # (Generated file. Do not modify.)

                $page_text
                """
            )
        end
    end
    headers_path = joinpath(project_root, "__site", "pages-headers.txt")
    mkpath(dirname(headers_path))
    Serialization.serialize(headers_path, pages_headers)
    pages_headers
end

"""
    toc(repo::Repo)

Copy the table of contents from the generated repo page.
This is a bit of a hacky way to pass the number of matches
per pattern per repository. 
"""
function toc(repo::Repo)
    pages_headers = 1
end

end # module
