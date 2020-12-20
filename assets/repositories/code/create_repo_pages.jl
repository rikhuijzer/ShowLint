# This file was generated, do not modify it. # hide
using Franklin

# hideall
using ShowLint
SL = ShowLint
using Serialization

headers_path = joinpath(SL.project_root, "__site", "pages-headers.txt")
pages_headers = isfile(headers_path) ?
  Serialization.deserialize(headers_path) :
  []