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
  #include "chapters/1-intro.typ"

  = Features
  #include "chapters/2-features.typ"
]

= Reference
#include "chapters/3-reference.typ"
