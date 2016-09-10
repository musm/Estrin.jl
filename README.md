
<!-- [![Build Status](https://travis-ci.org/musm/Estrin.jl.jl.svg?branch=master)](https://travis-ci.org/musm/Estrin.jl)

[![Coverage Status](https://coveralls.io/repos/musm/Estrin.jl.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/musm/Estrin.jl?branch=master)

[![codecov.io](http://codecov.io/github/musm/Estrin.jl.jl/coverage.svg?branch=master)](http://codecov.io/github/musm/Estrin.jl?branch=master)
 -->
# ParPoly.jl (WIP)

Exploration of parallelization for polynomial evaluation in Julia.



# To-do
- inbounds everywhere on estrin's alg (wip)

For now please use `julia -O3 --check-bounds=no` for comparison with Base `@evalpoly`

# Installation

```julia
Pkg.clone("https://github.com/musm/ParPoly.jl.git")
```

# Example

E.g.
```julia
x = 2.0
c = randn(Float64, 8)

f(x,c) = @horner_split x c[1] c[2] c[3] c[4] c[5] c[6] c[7] c[8]
# compare with 
g(x,c) = Base.Math.@horner x c[1] c[2] c[3] c[4] c[5] c[6] c[7] c[8]


```
