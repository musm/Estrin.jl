# doesn't fully work WIP
macro estrin(t, c...)
    N = length(c) ÷ 2

    tl = Expr(:tuple)
    tr = Expr(:tuple)
    for i = 1:N
        push!(tl.args, :(p[2($i)]))
        push!(tr.args, :(p[2($i)-1]))
    end
    
    a1 = gensym("a1") 
    a2 = gensym("a2") 
    a = gensym("a") 

    blk = quote
        x = $(esc(t))
        p = $(Expr(:tuple, map(esc, c)...))

        $(:(@inbounds $(a1) = Vec{$N,Float64}($tl)))
        $(:(@inbounds $(a2) = Vec{$N,Float64}($tr)))

        # $(a1) = Vec{$N,Float64}($tl)
        # $(a2) = Vec{$N,Float64}($tr)
        $(a) =  muladd($(a1), x, $(a2))
    end
    
   while N > 1
        ext = Expr(:block, :(x = x * x))
        N = N÷2

        tl = Expr(:tuple)
        tr = Expr(:tuple)
        for i = 1:N
            push!(tl.args, :($a[2($i)]))
            push!(tr.args, :($a[2($i)-1]))
        end

        a1 = gensym("a1") 
        a2 = gensym("a2") 
        a = gensym("a") 

        push!(ext.args, :(@inbounds $(a1) = Vec{$N,Float64}($tl)))
        push!(ext.args, :(@inbounds $(a2) = Vec{$N,Float64}($tr)))
        push!(ext.args, :($(a) = muladd($(a1), x, $(a2)) ))

        push!(blk.args,ext)
    end
    v = gensym("x") 
    push!(blk.args,:(@inbounds $v =  $(a)[1]))
    push!(blk.args,:($v))
    return blk
end
