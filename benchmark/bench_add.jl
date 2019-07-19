using SIMDHints: ivdep
using BenchmarkTools

f!(y, x) = y .= ivdep.(x .+ y)
g!(y, x) = y .= x .+ y

a = randn(2^10)
y = zero(a)

@btime f!($y, $y) setup=(fill!($y, 0))
@btime g!($y, $y) setup=(fill!($y, 0))
nothing
