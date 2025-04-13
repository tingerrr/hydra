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

= Chapter 1
#lorem(100)

== Section 1.1
