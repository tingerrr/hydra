/// Synopsis:
/// - <explanation>

#import "/src/lib.typ": hydra

#set page(
  paper: "a7",
  header: context hydra(),
)
#set heading(numbering: "1.1")
#show heading.where(level: 1): it => pagebreak(weak: true) + it
#set par(justify: true)


= Introduction
#lorem(200)

= Content
== First Section
#lorem(50)
== Second Section
#lorem(150)
