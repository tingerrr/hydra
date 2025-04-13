#import "/src/lib.typ": hydra

#set heading(numbering: "1.1")
#set par(justify: true)

#set page(
  paper: "a7",
  footer: context (
    none,
    [1 Chapter],
    [2.1 Section],
    [2.2 Section],
    [2.2 Section],
  ).at(counter(page).get().first() - 1),
)

= Chapter
#lorem(100)

= Chapter
== Section
#lorem(100)

== Section
#lorem(100)
