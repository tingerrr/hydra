// Synopsis:
// - when a page starts with a primary element it is displayed

#import "/src/lib.typ": hydra

#set page(paper: "a7", header: hydra(skip-starting: false, 2))
#set heading(numbering: "1.1")
#show heading.where(level: 1): it => pagebreak(weak: true) + it
#set par(justify: true)

= Content
== First Section
#lorem(150)
== Second Section
#lorem(50)

= Second Chapter
== Another Section
#lorem(10)
