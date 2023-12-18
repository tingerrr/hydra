#import "/src/lib.typ": hydra

#set page(paper: "a7", margin: (inside: 20pt, outside: 15pt), header: hydra(paper: "a7", binding: left))
#set heading(numbering: "1.1")
#show heading.where(level: 1): it => pagebreak(weak: true) + it
#set par(justify: true)

= Introduction
#lorem(150)

= Content
== First Section
#lorem(150)
== Second Section
#lorem(150)
== Third Section
#lorem(100)

= Annex
#lorem(250)
