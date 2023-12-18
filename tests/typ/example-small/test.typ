#import "/src/lib.typ": hydra

#set page(paper: "a7", header: hydra(paper: "a7"))
#set heading(numbering: "1.1")
#show heading.where(level: 1): it => pagebreak(weak: true) + it

= Introduction
#lorem(150)

= Content
== First Section
#lorem(100)
== Second Section
#lorem(150)
== Third Section
#lorem(100)

= Annex
#lorem(50)
