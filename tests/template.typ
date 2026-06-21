/// Synopsis:
/// - <explanation>

#import "/tests/style.typ": style
#show: style

#import "/src/lib.typ": hydra
#set page(header: context hydra())


= Introduction
#lorem(200)

= Content
== First Section
#lorem(50)
== Second Section
#lorem(150)
