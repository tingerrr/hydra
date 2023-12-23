#import "/src/lib.typ": hydra, custom

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

#let hydra = hydra.with(paper: "a7")

#set page(paper: "a7", header: locate(loc => {
  let chap = hydra(
    sel: custom(chapter-sel),
    display: (ctx, e) => {
      if e.has("numbering") and e.numbering != none {
        numbering(e.numbering, ..counter(ctx.self.func).at(e.location()))
        [ ]
      }

      e.body
    },
    loc: loc,
  )
  let sec = hydra(
    sel: custom(heading.where(level: 1), ancestor: chapter-sel),
    loc: loc,
  )

  chap
  if chap != none and sec != none [ --- ]
  sec
}))
#set heading(numbering: "1.1")

#chapter[Introduction]
#lorem(150)

#chapter[Content]
= First Section
#lorem(100)
= Second Section
#lorem(50)
#figure[Fake figure]
= Third Section
#lorem(100)

#chapter[Annex]
#lorem(50)
