// Synopsis:
// - When both last and prev candidates where none hydra would fall back to a heading defined on a future page.
//   Headings defined after the current page should never be displayed.

#import "/src/lib.typ": hydra

#set page(
  paper: "a7",
  header: context hydra(),
)
#set heading(numbering: "1.1")
#show heading.where(level: 1): it => pagebreak(weak: true) + it
#set par(justify: true)

#lorem(100)

= Introduction
#lorem(100)

