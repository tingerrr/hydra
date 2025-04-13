/// Synopsis:
/// - When both last and prev candidates are none, hydra should not fall back to
///   a candidate defined on a future page. Candidates defined after the current
///   page should never be displayed.

#import "/src/lib.typ": hydra

#set heading(numbering: "1.1")
#set par(justify: true)

#set page(
  "a7",
  header: context hydra(2),
)

= Chapter
#lorem(100)

== Section
