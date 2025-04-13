/// Synopsis:
/// - The search for active elements is always scoped to its nearest transitive
///   ancestors, if an ancestors is encountered the search does not prceed
///   further.

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
