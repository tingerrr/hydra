# hydra
Hydra is a [typst] package allowing you to easily display the heading like elements anywhere in your
document. In short, it will show you the currently active element only when it is not visible.

## Example
```typst
#import "@preview/hydra:0.4.0": hydra

#set page(header: context hydra() + line(length: 100%))
#set heading(numbering: "1.1")
#show heading.where(level: 1): it => pagebreak(weak: true) + it

= Introduction
#lorem(750)

= Content
== First Section
#lorem(500)
== Second Section
#lorem(250)
== Third Section
#lorem(500)

= Annex
#lorem(10)
```
![ex]

## Documentation
For a more in-depth description of hydra's functionality and the reference read its [manual].

## Contribution
For contributing, please take a look [CONTRIBUTING][contrib].

[ex]: examples/example.png
[manual]: doc/manual.pdf
[contrib]: CONTRIBUTING.md

[typst]: https://github.com/typst/typst
