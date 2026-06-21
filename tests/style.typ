#let style(body) = {
  // Use small pages with justified content to more easily fine tune layout.
  set page(paper: "a7")
  set par(justify: true)

  // Add numbering for the common case.
  set heading(numbering: "1.1")

  // Add automatic chapter page breaks.
  show heading.where(level: 1): it => pagebreak(weak: true) + it

  body
}
