/// Skipped because of minor floating point differences causing a mismatch.
///
/// Synopsis:
/// - Usage of an anchor ensures query results consistent with those in the
///   header.

#import "/src/lib.typ": hydra, anchor

#set heading(numbering: "1.1")
#set par(justify: true)

#set page(
  paper: "a7",
  header: anchor(),
  footer: context hydra(),
)

= Chapter
#lorem(100)

= Chapter
== Section
#lorem(100)

== Section
#lorem(100)
