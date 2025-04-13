/// Synopsis:
/// - Hydra should not fall back to the current page if `use-last: false` is
///   used.

#import "/src/lib.typ": hydra

#set heading(numbering: "1.1")
#set par(justify: true)

#set page(
  "a7",
  header: context hydra(2, use-last: false),
)

= Chapter 1
#lorem(100)

== Section 1.1
