# This file was generated, do not modify it. # hide
# hideall

# first_config = joinpath(project_root(), "configs", "one.toml")
cmd = `comby -config configs/p1.toml -f toml`
stdout = IOBuffer()
run(pipeline(cmd; stdout))
out = String(take!(stdout))
# println(out)
out = ansi2html(out)
println(out)