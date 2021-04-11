module ShowLint

using Dates
using DocStringExtensions
using Formatting
using Serialization

export 
    apply,
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

const project_root = dirname(dirname(pathof(ShowLint)))
const configs_dir = joinpath(project_root, "configs")

"""
Remove ANSI color codes from `text`.

$(TYPEDSIGNATURES) 
"""
function ansi2html(text::String)::String
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
  text = replace(text, "/home/runner/clones/github/" => "")
  text = replace(text, "" => "") 
  text = replace(text, "<!" => "&#60;!")
  text = replace(text, "[0;7;2m" => "")
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

"""
Directory of the host of `repo`. 

$(TYPEDSIGNATURES)

### Example
```
julia> host_dir("https://github.com") 
"github"
```
"""
function host_dir(repo::Repo)::String
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

function clone_repositories(; production=is_production())
    if !isdir(clones_dir)
        mkdir(clones_dir)
    end
    for repo in repositories(; production)
        println("Cloning $(repo.name)")
        name = repo.name
        host = repo.host
        dest = target_dir(repo)
        if isdir(dest)
            cd(dest)
            try
                run(`git pull --ff-only`)
            catch
                @warn "git pull failed for $(repo.name)"
            end
        else
            run(`git clone
                --depth=1
                --no-tags
                --single-branch
                $host/$name $dest`)
        end
        println()
    end
end

function config_path(pat::Pattern)::String
    id = pat.id
    name = "p$id"
    joinpath(configs_dir, "$name.toml")
end

"""
Create a Comby configuration file for `pat` at `dir`.

$(TYPEDSIGNATURES)
"""
function write_config(pat::Pattern, dir::String)
    open(config_path(pat), "w") do io
        write(io, pat.toml)
    end
end

"""
Write Comby configurations from `src/patterns.jl` to `project_root/configs`.

$(TYPEDSIGNATURES)
"""
function write_configs()
    rm(configs_dir; force=true, recursive=true)
    mkpath(configs_dir)
    for pat in patterns
        write_config(pat, configs_dir)
    end
end

"""
Obtains the number of matches from Comby's `-stats` output 
on stderr.

$(TYPEDSIGNATURES)
"""
function number_of_matches(stderr::String)::Int
    regex = r"\"number_of_matches\": ([0-9]*)"
    m = match(regex, stderr)
    n_str = m[1]
    parse(Int, n_str)
end

"""
Apply `pattern` to `repo`.

$(TYPEDSIGNATURES)
"""
function apply(pat::Pattern, repo::Repo; 
    file_extensions="jl", in_place=false)

    start = Dates.now()
    repo_path = target_dir(repo)

    exclude_prefixes = join(repo.exclude_prefixes, ',')
    stats_path = joinpath(tempdir(), "comby_stats.log")

    cmd = !in_place ? 
        `comby
            -exclude-dir $exclude_prefixes
            -config $(config_path(pat))
            -directory $repo_path
            -file-extensions $file_extensions
            -stats
        ` :
        `comby
            -exclude-dir $exclude_prefixes
            -config $(config_path(pat))
            -directory $repo_path
            -file-extensions $file_extensions
            -in-place
        `

    stdout = IOBuffer()
    stderr = IOBuffer()
    run(pipeline(cmd; stdout, stderr))
    out = String(take!(stdout))
    err = String(take!(stderr))
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
    end
    time = Dates.now() - start
    println("$(pat.id): $time")
    return (out, err)
end

"""
Apply `pattern` to `code`.

$(TYPEDSIGNATURES)
"""
function apply(pat::Pattern, code::String; file_extension="jl")
    test_dir = joinpath(clones_dir, "tmp", "tmp")
    rm(test_dir; recursive=true, force=true)
    mkpath(test_dir)

    code_file = joinpath(test_dir, "code.$file_extension")
    open(code_file, "w") do io
        write(io, code)
    end
    
    repo = Repo("tmp", "tmp"; exclude=["nah"])

    apply(pat, repo; in_place=true)

    read(code_file, String)
end

function filter_patterns(repo::Repo, patterns::Vector{Pattern})
    predicates = repo.tags_predicates
    all_predicates_hold(tags) = all([P(tags) for P in predicates])
    filtered_patterns = filter(pat -> all_predicates_hold(pat.tags), patterns)
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
    filtered_patterns = filter_patterns(repo, patterns)
    sections = pattern_section.(filtered_patterns)

    return (
        headers = headers,
        text = join([head, sections...], '\n') 
    )
end


"""
Create one webpage per repository.
We could process all the diffs when this function is called or when `serve` runs. 
It seems more flexible to do it as early as possible.

$(TYPEDSIGNATURES)
"""
function create_repo_pages(; production=is_production())
    write_configs()
    pages_headers = []

    for repo in repositories(; production)
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

function count_without_comments(path)::Int
    content = read(path, String)
    lines = split(content, '\n')
    is_comment_line(line) = startswith(lstrip(line), '#')
    non_comment_lines = filter(!is_comment_line, lines)
    length(non_comment_lines)
end

"""
Counts the number of lines of codes in files with `extension` in
`dir`.

$(TYPEDSIGNATURES)
"""
function cloned_loc(; extension=".jl")::Int
    counts = []
    
    for (root, dirs, files) in walkdir(clones_dir)
        for file in files
            ext = last(splitext(file))
            if ext == extension 
                path = joinpath(root, file)
                count = count_without_comments(path)
                push!(counts, count)
            end
        end
    end
    sum(counts)
end

prettify_loc(n::Number)::String = format(n, commas=true)

"""
Helper function to build the site locally.
`Franklin.serve` can be called after this function, but it is also possible to have Franklin already running.

$(TYPEDSIGNATURES)
"""
function build_site(; production=true)
    clone_repositories()
    create_repo_pages()
end

end # module
