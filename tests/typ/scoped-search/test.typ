#import "/src/lib.typ": hydra

#set heading(numbering: "1.1")
#show heading.where(level: 1): it => pagebreak(weak: true) + it
#set par(justify: true)

#set page(paper: "a7",
  header: locate(loc => {
    if calc.even(loc.page()) {
      hydra(sel: heading.where(level: 1))
    } else {
      [#h(1fr)#hydra(sel: heading.where(level: 2))]
    }
  }),
)

= First chapter
#lorem(10)
== First chapter first section
#lorem(150)
== First chapter second section
#lorem(20)
= Second
#lorem(10)
=== Second chapter first subsection
#lorem(30)
=== Second chapter second subsection
#lorem(40)
