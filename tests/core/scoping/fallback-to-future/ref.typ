#import "/src/lib.typ": hydra

#set heading(numbering: "1.1")
#set par(justify: true)

#set page(
  "a7",
  header: context (
    none,
    [1.1 Section],
  ).at(counter(page).get().first() - 1),
)

= Chapter
#lorem(100)

== Section
