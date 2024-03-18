#import "/src/lib.typ": hydra

#set page(paper: "a7", margin: (y: 4em), numbering: "1", header: context {
  // set text(8pt)
  if calc.odd(here().page()) {
    align(right, emph(hydra(1)))
  } else {
    align(left, emph(hydra(2)))
  }
  line(length: 100%)
})
#set heading(numbering: "1.1")
#show heading.where(level: 1): it => pagebreak(weak: true) + it

= Introduction
#lorem(50)

= Content
== First Section
#lorem(50)
== Second Section
#lorem(100)
