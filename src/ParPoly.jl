module ParPoly

export @estrin, @horner_split, @horner_split_simd
using SIMD

include("estrin.jl")


macro horner_split_simd(t,p...)
    x1   = gensym("x1")
    x2   = gensym("x2")
    x1x2 = gensym("x1x2")
    x2x2 = gensym("x2x2")

    blk = quote
        T = typeof($(esc(t)))
        $x1 = $(esc(t))
        $x2 = $(esc(t)) * $(esc(t))
        $x1x2 = Vec{2,T}(($x1,$x2))
        $x2x2 = Vec{2,T}(($x2,$x2))
    end
    n = length(p)
    p0 = esc(p[1])    
    m = n÷2
    c = Array(Symbol,m)
    for i = 1:m
        c[i] = gensym("c$i")
    end

    if isodd(n)
        for i = 1:m
            push!(blk.args, :( $(c[i]) = Vec{2,T}(( $(esc(p[2i])), $(esc(p[2i+1])) )) ))
        end
    elseif iseven(n)
        for i = 1:m-1
            push!(blk.args, :( $(c[i]) = Vec{2,T}(( $(esc(p[2i])), $(esc(p[2i+1])) )) ))
        end
        push!(blk.args, :( $(c[m]) = Vec{2,T}(( $(esc(p[2m])), zero(T) )) )) # pad with a zero
    end

    ex = c[end]
    for i = m-1:-1:1
        ex = :(muladd($(x2x2), $ex, $(c[i])))
    end
    cc = gensym("cc")
    push!(blk.args, :($p0 + sum($x1x2*$ex) ))

    return blk
end


macro horner_split(x,p...)
    t = gensym("x1")
    t2 = gensym("x2")
    blk = quote
        $t = $(esc(x))
        $t2 = $(esc(x)) * $(esc(x))
    end

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

    
    return blk
end

end
