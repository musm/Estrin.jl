
<!-- [![Build Status](https://travis-ci.org/musm/Estrin.jl.jl.svg?branch=master)](https://travis-ci.org/musm/Estrin.jl)

[![Coverage Status](https://coveralls.io/repos/musm/Estrin.jl.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/musm/Estrin.jl?branch=master)

[![codecov.io](http://codecov.io/github/musm/Estrin.jl.jl/coverage.svg?branch=master)](http://codecov.io/github/musm/Estrin.jl?branch=master)
 -->
# ParPoly.jl (WIP)

Exploration of parallelization for polynomial evaluation in Julia.


# Installation

```julia
Pkg.clone("https://github.com/musm/ParPoly.jl.git")
```

# Introduction & Examples

This package so far exports two tested macros:  `@horner_split` and `@horner_split_simd`. (Estrin's scheme through `@esterin` is WIP)

E.g.
```julia
using ParPoly

const c0 = 1.0
const c1 = 2.0
const c2 = 3.0
const c3 = 4.0
const c4 = 5.0
const c5 = 6.0
const c6 = 7.0
const c7 = 8.0
const c8 = 9.0
const c9 = 10.0
const c10 = 11.0
const c11 = 12.0
const c12 = 13.0
const c13 = 14.0
const c14 = 14.0

const x = 2.0

f(x) = @horner_split x c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14
g(x) = @horner_split_simd x c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14

# compare with 
w(x) = Base.Math.@horner x c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14

```

# Simple Benchmark

Using `Benchmarks.jl`


```
using Benchmarks

f(x); g(x); w(x);  # precompile the functions first

julia> @benchmark f(x)
================ Benchmark Results ========================
     Time per evaluation: 6.80 ns [6.64 ns, 6.96 ns]
Proportion of time in GC: NaN% [0.00%, 100.00%]
        Memory allocated: 0.00 bytes
   Number of allocations: 0 allocations
       Number of samples: 9101
   Number of evaluations: 11691001
         R² of OLS model: 0.877
 Time spent benchmarking: 10.04 s


julia> @benchmark g(x)
================ Benchmark Results ========================
     Time per evaluation: 5.98 ns [5.84 ns, 6.12 ns]
Proportion of time in GC: NaN% [0.00%, 100.00%]
        Memory allocated: 0.00 bytes
   Number of allocations: 0 allocations
       Number of samples: 9301
   Number of evaluations: 14145701
         R² of OLS model: 0.883
 Time spent benchmarking: 10.09 s


julia> @benchmark w(x)
================ Benchmark Results ========================
     Time per evaluation: 9.89 ns [8.93 ns, 10.86 ns]
Proportion of time in GC: NaN% [0.00%, 100.00%]
        Memory allocated: 0.00 bytes
   Number of allocations: 0 allocations
       Number of samples: 9001
   Number of evaluations: 10628301
         R² of OLS model: 0.295
 Time spent benchmarking: 10.12 s
```

