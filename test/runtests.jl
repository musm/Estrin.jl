using ParPoly
# using Base.Test

# using SIMD
# x = 2.0
# c = randn(Float64, 16)

# g(x,c) = @estrin   x c[1] c[2] c[3] c[4] c[5] c[6] c[7] c[8]
# f(x,c) = @evalpoly x c[1] c[2] c[3] c[4] c[5] c[6] c[7] c[8]

# @test g(x,c) ≈ f(x,c)


# @code_native g(x,c)

# macroexpand(:(@estrin x c[1] c[2] c[3] c[4] c[5] c[6] c[7] c[8]))


# @time f(x,c)
# @time g(x,c)

