#import "util.typ": package, bbox, mantys, issues, sub-file

#import "/src/lib.typ" as hydra

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

#show raw.line: it => {
  show "{{VERSION}}": package.version
  it
}

#show terms: it => table(
  columns: 2,
  gutter: 0.25em,
  align: (right, left),
  stroke: none,
  table.vline(x: 1),
  ..it.children.map(i => (strong(i.term), i.description)).flatten(),
)

= Manifest
HYDRA aims to be:
- simple to use
  - importing a function and using it should be all that is needed
  - setup required to make the package work should be avoided
- unsurprising
  - parameters should have sensible names and behave as one would expect
  - deviations from this must be documented and easily accesible to Typst novices
- interoperable
  - HYDRA should be easy to use with other packages by default or provide sufficient configuration to allow this in other ways
- minimal
  - it should only provide features which are specifically used for heading and section querying and display

If you think its behvior is surprising, you believe you found a bug or you think its defaults or parameters are not sufficient for your use case, please open an issue at #issues.
Contributions are also welcome!

= Guide
#sub-file("chapters/2-guide.typ")

= Reference <api>
#sub-file("chapters/3-reference.typ")
