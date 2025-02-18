#set heading(numbering: "1.1")
#show heading.where(level: 1): it => pagebreak(weak: true) + it
#set par(justify: true)

= Content
== First Section
#lorem(150)
== Second Section
#lorem(50)

= Second Chapter
== Another Section
#lorem(10)
