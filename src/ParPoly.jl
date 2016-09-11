module ParPoly

export @estrin, @horner_split, @horner_split_simd
using SIMD

include("estrin.jl")


macro horner_split_simd(t,p...)
    # T = typeof($(esc(t)))
    x1   = gensym("x1")
    x2   = gensym("x2")
    x1x2 = gensym("x1x2")
    x2x2 = gensym("x2x2")

    blk = Expr(:block, :($x1 = $(esc(t))))
    push!(blk.args, :($x2 = $x1 * $x1))
    push!(blk.args, :($x1x2 = Vec{2,Float64}(($x1,$x2))))
    push!(blk.args, :($x2x2 = Vec{2,Float64}(($x2,$x2))))

    n = length(p)
    p0 = esc(p[1])    
    if isodd(n)
        m = n÷2
        c = Array(Symbol,m)
        for i = 1:m
            c[i] = gensym("c$i")
        end
        for i = 1:m
            push!(blk.args, :( $(c[i]) = Vec{2,Float64}(( $(esc(p[2i])), $(esc(p[2i+1])) )) ))
        end

        ex = c[end]
        for i = m-1:-1:1
            ex = :(muladd($(x2x2), $ex, $(c[i])))
        end
        cc = gensym("cc")
        push!(blk.args, :($cc = $ex) )
        push!(blk.args, :($p0 + sum($x1x2*$cc) ))

    elseif iseven(n)
        m = n÷2
        c = Array(Symbol,m)
        for i = 1:m
            c[i] = gensym("c$i")
        end
        for i = 1:m-1
            push!(blk.args, :( $(c[i]) = Vec{2,Float64}(( $(esc(p[2i])), $(esc(p[2i+1])) )) ))
        end
        push!(blk.args, :( $(c[m]) = Vec{2,Float64}(( $(esc(p[2m])), $(zero(Float64)) )) ))

        ex = c[end]
        for i = m-1:-1:1
            ex = :(muladd($(x2x2), $ex, $(c[i])))
        end
        cc = gensym("cc")
        push!(blk.args, :($cc = $ex) )
        push!(blk.args, :($p0 + sum($x1x2*$cc) ))
    end

    return blk
end


macro horner_split(x,p...)
    t = gensym("x1")
    t2 = gensym("x2")
    blk = Expr(:block, :($(t) = $(esc(x))))
    push!(blk.args, :($(t2) = $(t)*$(t)))

    n = length(p)
    p0 = esc(p[1])
    
    if isodd(n)
        ex_o = esc(p[end-1])
        ex_e = esc(p[end])

        for i = n-3:-2:2
            ex_o = :(muladd($(t2), $ex_o, $(esc(p[i]))))
        end
        for i = n-2:-2:2
            ex_e = :(muladd($(t2), $ex_e, $(esc(p[i]))))
        end

        c_e = gensym("c_e")
        c_o = gensym("c_o")
        push!(blk.args, :($(c_o) = $(ex_o)) )
        push!(blk.args, :($(c_e) = $(ex_e)) )

        push!(blk.args,:($(p0) + $(t)*$(c_o) + $(t2)*$(c_e)) )
    elseif iseven(n)
        ex_o = esc(p[end])
        ex_e = esc(p[end-1])

        for i = n-2:-2:2
            ex_o = :(muladd($(t2), $ex_o, $(esc(p[i]))))
        end
        for i = n-3:-2:2
            ex_e = :(muladd($(t2), $ex_e, $(esc(p[i]))))
        end

        c_e = gensym("c_e")
        c_o = gensym("c_o")
        push!(blk.args, :($(c_o) = $(ex_o)) )
        push!(blk.args, :($(c_e) = $(ex_e)) )
        push!(blk.args,:($(p0) + $(t)*$(c_o) + $(t2)*$(c_e)) )
    end

    return blk
end

end
