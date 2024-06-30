// Synopsis:
// - When there are multiple ancestors on one page hydra should still show the last heading

#import "/src/lib.typ": hydra

#set page(
  paper: "a7",
  header: context hydra(2, use-last: true),
)
#set heading(numbering: "1.1")
#set par(justify: true)


= Introduction
== First Section
#lorem(50)
== Second Section
#lorem(100)
== Third section
#lorem(50)

= Other
#lorem(10)
== test
#lorem(10)
= More
#lorem(5)
== more tests
#lorem(10)
