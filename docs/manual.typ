#import "template.typ": project, raw-bg
#import "util.typ": package, bbox

#show: project.with(
  package: package,
  date: datetime.today(),
  abstract: [
    A package for querying and displaying heading-like elements.
  ],
)

#[
  #show raw.where(block: false): bbox.with(fill: raw-bg)

  = Introduction
  #include "1-intro.typ"

  = Features
  #include "2-features.typ"
]

= Reference
#include "3-reference.typ"
