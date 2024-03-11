// Synopsis:
// - the figure doesnt interfere with chapter numbering
// - the use of `loc: loc` ensures that return values can be used for logic
// - the use of `custom` ensures that heading searches are scoped by chapters

#import "/src/lib.typ" as hydra
#import hydra.selectors: custom
#import hydra: hydra

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

#set page(paper: "a7", header: context {
  let chap = hydra(chapter-sel, display: display-chapter)
  let sec = hydra(custom(heading.where(level: 1), ancestors: chapter-sel))

  chap
  if chap != none and sec != none [ --- ]
  sec
})
#set heading(numbering: "1.1")
#set par(justify: true)

#chapter[Introduction]
#lorem(100)

#chapter[Content]
= First Section
#figure[Fake figure]
#lorem(120)

= Second Section
#lorem(50)
