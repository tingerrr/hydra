#import "template.typ": project, raw-bg
#import "util.typ": package, bbox, mantys

#show "Hydra": mantys.package

#show: mantys.mantys.with(
  ..package,
  title: [hydra],
  subtitle: [/ˈhaɪdrə/],
  date: datetime.today().display(),
  abstract: [
    Hydra provides a simple API to querying for headings und section like elements and displaying them in headers or footers.
    It exposes internal modules and functions for maximum control.
  ],
)

#show raw: it => {
  show "{{VERSION}}": package.version
  it
}

= Manifest
Hydra aims to be:
- simple to use
  - importing a function and using it should be all that is needed
  - setup required to make the package work should be avoided
- unsurprising
  - parameters should have sensible names and behave as one would expect
  - deviations from this must be documented and easily accesible to Typst novices
- interoperable
  - Hydra should be easy to use with other packages by default or provide sufficient configuration to allow this in other ways
- minimal
  - it should only provide features which are specifically used for heading and section querying and display

If you think its behvior is surprising, you believe you found a bug or you think its defaults or parameters are not sufficient for your use case, please open an issue at #text(eastern, link("https://github.com/tingerrr/hydra")[GitHub:tingerrr/hydra]).
Contributions are also welcome!

= Guide
== Introduction
#include "chapters/1-intro.typ"

== Features
#include "chapters/2-features.typ"

= Reference
#include "chapters/3-reference.typ"
