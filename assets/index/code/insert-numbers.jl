# This file was generated, do not modify it. # hide
# hideall
using ShowLint; SL = ShowLint
n_patterns = length(SL.patterns)
n_repositories = length(SL.repositories)

println("""
- [$n_patterns patterns](/patterns) on 
- [$n_repositories repositories](/repositories).
""")