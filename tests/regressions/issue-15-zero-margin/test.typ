/// Synopsis:
/// - Hydra can properly handle a zero-length margin and does not panic.

#import "/src/lib.typ": hydra

#set heading(numbering: "1.1")
#set par(justify: true)

#set page(
  paper: "a7",
  margin: 0pt,
  header: context hydra(),
)

= Chapter
#lorem(100)

= Chapter
== Section
#lorem(100)

== Section
#lorem(100)
