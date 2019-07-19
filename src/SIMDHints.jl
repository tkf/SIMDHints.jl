module SIMDHints

export simd, ivdep

using Base.Broadcast: Broadcasted, BroadcastStyle, throwdm, preprocess

abstract type SIMDHint end

struct SIMD{T} <: SIMDHint
    value::T
end

struct IVDEP{T} <: SIMDHint
    value::T
end

simd(x) = SIMD(x)
ivdep(x) = IVDEP(x)

struct SIMDStyle{f} <: BroadcastStyle end

const HintFuncType = Union{typeof(simd), typeof(ivdep)}

Broadcast.broadcasted(f::HintFuncType, x) =
    Broadcasted{SIMDStyle{f}}(identity, (x,))

@inline function Base.copyto!(dest::AbstractArray, bc::Broadcasted{SIMDStyle{f}}) where f
    axes(dest) == axes(bc) || throwdm(axes(dest), axes(bc))
    @assert bc.f === identity
    @assert bc.args isa Tuple{Any}
    bc′ = preprocess(dest, bc.args[1])
    if f === ivdep
        @simd ivdep for I in eachindex(bc′)
            @inbounds dest[I] = bc′[I]
        end
    else
        @simd for I in eachindex(bc′)
            @inbounds dest[I] = bc′[I]
        end
    end
    return dest
end

end # module
