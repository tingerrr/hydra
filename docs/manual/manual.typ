#import "util.typ": mantys, package

#show: mantys.mantys(
  ..package,
  title: [hydra],
  subtitle: [/ˈhaɪdrə/],
  date: datetime.today().display(),
  abstract: [
    Hydra provides a simple API to query for headings und section like elements and display them in your document's headers.
    It aids in creating headers and footers with navigational snippets.
  ],
  // TODO(tinger): This seems to be unaffected in typstyle `0.13.14`.
  theme: /* @typstyle off */ mantys.create-theme(
    fonts: (sans: "TeX Gyre Heros"),
    heading: (font: "TeX Gyre Heros"),
  ),
)

// replace the version in all examples with the current version
#show raw.line: it => {
  show "{{VERSION}}": package.version
  it
}

// use codesnippet by default
#show raw.where(block: true): mantys.codesnippet

// prettify figures
#show figure.caption: it => context block(inset: (x: 0.7em), grid(
  columns: 2,
  gutter: 0.5em,
  align: (right, left),
  text(font: "TeX Gyre Heros", weight: "bold", {
    it.supplement
    [ ]
    numbering(it.numbering, ..counter(figure.where(kind: it.kind)).get())
  }),
  it.body,
))

#include "chapters/guide.typ"
#include "chapters/reference.typ"
