module Estrin

export @estrin
using SIMD

macro estrin(t, c...)
    N = length(c) ÷ 2

    tl = Expr(:tuple)
    tr = Expr(:tuple)
    for i = 1:N
        push!(tl.args, :(p[2($i)]))
        push!(tr.args, :(p[2($i)-1]))
    end
        
    blk = quote
        T = typeof($(esc(t)))
        x = $(esc(t))
        p = $(Expr(:tuple, map(esc, c)...))

        a1 = Vec{$N,T}($tl)
        a2 = Vec{$N,T}($tr)
        a =  muladd(a1, x, a2)
    end

   for j = 1:N-2
        ext = Expr(:block, :(x = x * x))
        N = N÷2
        tl = Expr(:tuple)
        tr = Expr(:tuple)
        for i = 1:N
            push!(tl.args, :(a[2($i)]))
            push!(tr.args, :(a[2($i)-1]))
        end
        push!(ext.args, :(a1 = Vec{$N,T}($tl)))
        push!(ext.args, :(a2 = Vec{$N,T}($tr)))
        push!(ext.args, :(a = muladd(a1, x, a2)))

        push!(blk.args,ext)
   end
    push!(blk.args,:(a[1]))
   return blk
end



end
