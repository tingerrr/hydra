#import "util.typ": raw-bg

#let project(
  package: (:),
  subtitle: none,
  abstract: [],
  date: none,
  body,
) = {
  set document(author: package.authors, title: package.name)
  set text(font: "Libertinus Serif")

  show heading.where(level: 1): smallcaps
 
  // title page
  page({
    v(4em)

    align(center, {
      block(text(weight: 700, 1.75em, eastern, package.name))
      if subtitle != none {
        block(subtitle)
      }
      v(4em, weak: true)
      [v#package.version]
      if date != none {
        h(1.2cm)
        date.display()
      }
      block(text(eastern, link(package.repository)))
    })

    v(1.5em, weak: true)

    pad(top: 0.5em, x: 2em,
      grid(
        columns: (1fr,) * calc.min(3, package.authors.len()),
        gutter: 1em,
        ..package.authors.map(author => align(center, strong(author))),
      ),
    )

    v(3cm, weak: true)
  
    pad(x: 3.8em, top: 1em, bottom: 1.1em,
      align(center)[
        #heading(outlined: false, text(0.85em)[Abstract])
        #abstract
      ],
    )
  })

  set par(justify: true)
  show list: set par(justify: false)
  show enum: set par(justify: false)
  show terms: set par(justify: false)
  show raw.where(block: true): set par(justify: false)

  // outline
  page({
    show outline.entry: it => if it.level == 1 {
      strong(it)
    } else {
      it
    }
    v(10em)
    outline(indent: auto)
  })

  set heading(numbering: (..args) => numbering("1.", ..args.pos().slice(1)))
  show heading.where(level: 1): it => pagebreak(weak: true) + it
  show heading.where(level: 1): set heading(
    numbering: (..args) => box(width: 1.5em, align(left, numbering("I", ..args))),
    supplement: [Chapter],
  )

  show raw.where(block: true): set block(
    fill: raw-bg,
    radius: 0.5em,
    inset: 0.5em,
    width: 100%,
  )
  show raw.where(block: true): it => {
    show "{{VERSION}}": package.version
    it
  }

  show link: set text(eastern)

  set table(stroke: none)
  show table: pad.with(x: 1em)

  show terms: its => table(
    columns: (auto, auto),
    align: (right, left),
    table.header(
      [*Term*], [*Description*],
      table.hline(stroke: 1pt),
    ),
    ..its.children.map(it => (
      align(right)[*#it.term*],
      align(left, par(justify: true, it.description)),
    )).flatten(),
  )

  set page(numbering: "1", number-align: center)
  counter(page).update(1)

  body
}
