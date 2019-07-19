using Documenter, SIMDHints

makedocs(;
    modules=[SIMDHints],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/tkf/SIMDHints.jl/blob/{commit}{path}#L{line}",
    sitename="SIMDHints.jl",
    authors="Takafumi Arakaki <aka.tkf@gmail.com>",
    assets=String[],
)

deploydocs(;
    repo="github.com/tkf/SIMDHints.jl",
)
