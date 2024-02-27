// Synopsis:
// - on even pages we still see the last heading if its on the previous page
// - on odd pages we don't see it and display it

#import "/src/lib.typ": hydra

#set page(
  paper: "a7",
  binding: right,
  margin: (inside: 30pt, outside: 15pt),
  header: hydra(book: true),
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
