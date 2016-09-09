
<!-- [![Build Status](https://travis-ci.org/musm/Estrin.jl.jl.svg?branch=master)](https://travis-ci.org/musm/Estrin.jl)

[![Coverage Status](https://coveralls.io/repos/musm/Estrin.jl.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/musm/Estrin.jl?branch=master)

[![codecov.io](http://codecov.io/github/musm/Estrin.jl.jl/coverage.svg?branch=master)](http://codecov.io/github/musm/Estrin.jl?branch=master)
 -->
# Estrin.jl (WIP)

Exploration of vectorization for polynomial evaluation in Julia.

This simply exports one macro `@estrin`  that expands to Estrin's algorithm using SIMD operations. Only works for odd polynomial sizes for now...

# To-do
- get rid type inference failure (wip)
- inbounds everywhere (wip)

# Installation

```julia
Pkg.clone("https://github.com/musm/Estrin.jl.git")
```

# Example

E.g.
```julia
x = 2.0
c = randn(Float64, 8)

g(x,c) = @estrin x c[1] c[2] c[3] c[4] c[5] c[6] c[7] c[8]
f(x,c) = @evalpoly x c[1] c[2] c[3] c[4] c[5] c[6] c[7] c[8]

g(x,c) 

f(x,c)
```
