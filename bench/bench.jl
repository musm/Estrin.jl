


using Benchmarks, PyPlot
using Base.Math.@horner, ParPoly

const x = 2.0
nn = 5:25
t_horner_split = []
t_horner = []
xt_horner_split = []
xt_horner = []

time_h = Float64[]
time_hs = Float64[]
time_hss = Float64[]
for n in nn
    println("running bench for order $(n-1)")
    c = randn(Float64,n)

    @gensym f1
    @gensym f2
    @gensym f3
    @eval begin
        $f1(x) = @horner x $(c...)
        $f2(x) = @horner_split x $(c...)
        $f3(x) = @horner_split x $(c...)
    end
    @eval begin
        $f1($x); $f2($x); $f3($x) # precompile them
    end
    t_h    = @benchmark @eval $f1($x)
    t_hs   = @benchmark @eval $f2($x)
    t_hss  = @benchmark @eval $f3($x)

    push!(time_h,   Benchmarks.SummaryStatistics(t_h).elapsed_time_center)
    push!(time_hs,  Benchmarks.SummaryStatistics(t_hs).elapsed_time_center)
    push!(time_hss, Benchmarks.SummaryStatistics(t_hss).elapsed_time_center)
end
plot(nn-1, time_h*0.001,   label="@horner")
plot(nn-1, time_hs*0.001,  label="@horner_split")
plot(nn-1, time_hss*0.001, label="@horner_split_simd")

legend(loc="upper left")
xlabel("polynomial order")
ylabel("time (ms)")
savefig("out.jpg")
 
