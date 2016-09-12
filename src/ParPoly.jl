module ParPoly

export @estrin, @horner_split
using SIMD

include("estrin.jl")


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
