# This file was generated, do not modify it. # hide
# hideall
using ShowLint; SL = ShowLint
n_patterns = length(SL.patterns)
n_repositories = length(SL.repositories())
n_loc = SL.cloned_loc()
pretty_n_loc = SL.prettify_loc(n_loc)
n_loc_text = "(about $pretty_n_loc lines of code)"

println("""
- [$n_patterns patterns](/patterns) on 
- [$n_repositories repositories](/repositories) $n_loc_text.
""")