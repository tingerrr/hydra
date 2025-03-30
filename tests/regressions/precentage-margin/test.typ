/// Synopsis:
/// - Tracked in #31.
/// - The smallest page should only be used for the `2.5 / 21` fallback.

#import "/src/lib.typ": hydra

#set page(
  paper: "a4",
  margin: (top: 10%),
  header: context hydra(1, skip-starting: false),
)

#show heading.where(level: 1): it => pagebreak(weak: true) + it

= Chapter 1
#lorem(100)

= Chapter 2
#lorem(200)

= Chapter 3
#lorem(200)
