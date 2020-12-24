+++
title = "Notes"
+++

# Notes

\toc

## Failed PRs

### Stale
- <https://github.com/GiovineItalia/Compose.jl/pull/407>

### Closed
- <https://github.com/JuliaDynamics/Agents.jl/pull/358> (`findall(!, Y)` not considered readable)
- <https://github.com/fonsp/Pluto.jl/pull/802> (`Vector`)
- <https://github.com/diegozea/MIToS.jl/pull/58> (`Vector`)

## Ease of validation

Generally, rewrites which can easily be validated seem to be more appreciated.
For example, compare rewriting 26 occurrences of 
```
f(a, b; c = c)
```
to
```
f(a, b; c)
```
at <https://github.com/JuliaDynamics/Agents.jl/pull/357> with rewriting 2 occurrences of
```
findall(x -> x == false, matches)
```
to
```
findall(!, matches)
```
at <https://github.com/JuliaDynamics/Agents.jl/pull/358/files>.

Clearly, the former is much bigger, but easier to validate.

## Size of rewrite

Unless the rewrite is easy to validate, bigger rewrites are less likely to be merged.

