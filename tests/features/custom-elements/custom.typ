#let chapter = figure.with(supplement: [Chapter], kind: "chapter")
#let chapter-sel = figure.where(kind: "chapter")

#show chapter-sel: it => {
  pagebreak(weak: true)

  set align(center)
  set text(32pt)

  counter(heading).update(0)
  [Chapter ]
  it.counter.display()
  linebreak()
  it.body
}

#let display-chapter(ctx, chapter) = {
  if chapter.has("numbering") and chapter.numbering != none {
    numbering(chapter.numbering, ..counter(chapter-sel).at(chapter.location()))
    [ ]
  }

  chapter.body
}
