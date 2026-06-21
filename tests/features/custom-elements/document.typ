#import "custom.typ": chapter, chapter-sel
#import "/tests/style.typ": style
#show: style

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

#chapter[Introduction]
#lorem(100)

#chapter[Content]
= First Section
#figure[Fake figure]
#lorem(120)

= Second Section
#lorem(50)
