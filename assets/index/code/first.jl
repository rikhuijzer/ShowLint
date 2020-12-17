# This file was generated, do not modify it. # hide
# hideall

cmd = `podman run
  --volume $project_root:/project
  --rm
  --workdir /project
  -it comby/comby
  -config configs/p1.toml
  -file-extensions toml
  `
stdout = IOBuffer()
run(pipeline(cmd; stdout))
out = String(take!(stdout))
out = ansi2html(out)
println(out)