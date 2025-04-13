/// Synopsis:
/// - <explanation>

#import "/src/lib.typ": hydra

#set heading(numbering: "1.1")
#set par(justify: true)

#set page(
  paper: "a7",
  header: context hydra(2),
)

= Chapter
== Section
#lorem(100)

= Chapter
=== Subsection
#lorem(100)
