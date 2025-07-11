/// Synopsis:
/// - Tracked in #5.
/// - If a level 2 heading cannot be found, then hydra will not go further than
///   a level 1 heading back, i.e. it respects ancestor boundaries.

#import "/src/lib.typ": hydra

#set heading(numbering: "1.1")
#show heading.where(level: 1): it => pagebreak(weak: true) + it
#set par(justify: true)

#set page(paper: "a7", header: context {
  if calc.even(here().page()) {
    align(left, hydra(1))
  } else {
    align(right, hydra(2))
  }
})

= First Chapter
== First section
#lorem(180)

= Second Chapter
=== Second Subscetion
#lorem(100)
