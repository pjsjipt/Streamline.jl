using Streamline
using Documenter

DocMeta.setdocmeta!(Streamline, :DocTestSetup, :(using Streamline); recursive=true)

makedocs(;
    modules=[Streamline],
    authors="= <pjabardo@ipt.br> and contributors",
    sitename="Streamline.jl",
    format=Documenter.HTML(;
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)
