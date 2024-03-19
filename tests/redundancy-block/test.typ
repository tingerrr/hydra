// Synopsis:
// - both the first and second part of the document should give the same result
// - page 4 and 5 don't contain a header, just like 1 and 2 don't

#import "/src/lib.typ": hydra

#set page(header: context hydra())

#let inner = it => {
  set text(2em, weight: "bold")
  v(8em)
  if it.numbering != none [
    Chapter #counter(heading).display()
    #v(.5em)
  ]
  it.body
  v(0.5em)
}

#[
  #show heading.where(level: 1) : it => pagebreak(weak: true) + block(inner(it))
  = First
  #hide[.]

  = Second
  #hide[.]
  #pagebreak()
  #pagebreak()
]

#[
  #show heading.where(level: 1) : it => pagebreak(weak: true) + inner(it)
  = First Again
  #hide[.]

  = Second Again
  #hide[.]
  #pagebreak()
]
