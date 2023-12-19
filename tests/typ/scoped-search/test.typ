#import "/src/lib.typ": hydra

#set heading(numbering: "1.1")
#show heading.where(level: 1): it => pagebreak(weak: true) + it
#set par(justify: true)

#set page(paper: "a7",
  header: locate(loc => {
    if calc.even(loc.page()) {
      hydra(sel: heading.where(level: 1), paper: "a7")
    } else {
      [#h(1fr)#hydra(sel: heading.where(level: 2), paper: "a7")]
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
#lorem(30)
== Second section zero
=== Second subsection one
#lorem(90)
== Second section one
#lorem(25)
= Third
#lorem(20)
== Third section one
#lorem(180)
= Fourth
#lorem(200)
