using BenchmarkTools, PyPlot
using Base.Math.@horner, ParPoly


bench(w::Function, X) = mapreduce(x -> reinterpret(Unsigned,x), |, w(x) for x in X)
X = randn(10_000_000)

nn = 5:25
time_h = Float64[]
time_hs = Float64[]
time_hss = Float64[]
for n in nn
    println("running bench for order $n")
    c = randn(Float64,n+1)

    @gensym f1
    @gensym f2
    @gensym f3
    @eval begin
        $f1(x) = @horner x $(c...)
        $f2(x) = @horner_split x $(c...)
        $f3(x) = @horner_split_simd x $(c...)
    end
    @eval begin
        $f1(2.); $f2($2.); $f3($2.) # precompile them
    end
    t_h    = @benchmark bench($f1, $X)
    t_hs   = @benchmark bench($f2, $X) 
    t_hss  = @benchmark bench($f3, $X)

    push!(time_h,   median(t_h).time)
    push!(time_hs,  median(t_hs).time)
    push!(time_hss, median(t_hss).time)
end

plot(nn, time_h*0.000001,   label="@horner")
plot(nn, time_hs*0.000001,  label="@horner_split")
plot(nn, time_hss*0.000001, label="@horner_split_simd")

legend(loc="upper left")
xlabel("polynomial order")
ylabel("time (ms)")
savefig("out.jpg")
 
