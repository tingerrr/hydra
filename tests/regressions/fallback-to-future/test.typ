/// Synopsis:
/// - Not tracked.
/// - When both last and prev candidates are none, hydra should not fall back to
///   a candidate defined on a future page. Candidates defined after the current
///   page should never be displayed.

#import "/src/lib.typ": hydra

#set page(paper: "a7", header: context hydra())
#set heading(numbering: "1.1")
#show heading.where(level: 1): it => pagebreak(weak: true) + it
#set par(justify: true)

#lorem(100)

= Introduction
#lorem(100)
