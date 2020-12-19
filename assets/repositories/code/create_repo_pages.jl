# This file was generated, do not modify it. # hide
using Franklin

# hideall
using ShowLint
SL = ShowLint

debug = true

if haskey(ENV, "CI")
  debug = false
end

pages_headers = SL.create_repo_pages(; debug)