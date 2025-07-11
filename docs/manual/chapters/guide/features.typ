#import "/docs/manual/util.typ": issue, load-examples, mantys, show-examples
#import mantys: *

== Features
Let's go over some of HYDRA's features in no particular order, some of these features are enabled by default and can be disabled, others are deliberately turned off.

=== Contextual
@cmd:hydra will take contextual information into account to provide good defaults.
These include inferring the reading direction and binding from the page and text styles respectively and using the top margin to correctly identify primary elements on page starts.
This is used to offer correct handling of books as seen in @sec:book-mode or to remove redundant headers as in @sec:redundancy.

=== Redundancy Checks <sec:redundancy>
@cmd:hydra is generally used for heading-like elements, i.e. elements which annotate a section inside of a document.
Whenever @cmd:hydra is used in a place where its output is considered redundant for the reader, it will not show any output by default.
The following sections explain those checks more closely and will generally assume that @cmd:hydra is looking for headings.

==== Skip Starting Pages <sec:starting-page>
When a new page starts and introduced a chapter or heading it's usually unecessary to show that same chapter or section in the header.
Infact, for chapters this is undesirable too.
If @cmd:hydra is used with #arg(skip-starting: true) on such a starting page, it will not show anything.
This is turned on by default.

#let skip = load-examples("skip")
#figure(
  frame(grid(
    columns: 2,
    gutter: 1em,
    show-examples(skip.a), show-examples(skip.b),
  )),
  caption: [
    Two example documents showing the difference between #arg(skip-starting: true) (left) and #arg(skip-starting: false) (right).
  ],
)

For more complex selectors this will not correctly work if the first element on this page is an ancestor, see #issue(8).
You should also make sure you don't use show rules which affect the vertical starting position of the heading.

#figure(
  ```typst
  // do
  #show heading: it => block(v(8cm) + it)

  // don't
  #show heading: it => v(8cm) + it
  ```,
  caption: [
    Two different show rules which look the same but have an impact on @cmd:hydra.
    The first rule will allow @cmd:hydra to correctly detect elements, the second one will not, this is related to how Typst calculates an element location.
  ],
)

#warning-alert[
  The example above serves as a quick fix, but if you're using ```typst #v(8cm)``` for vertical spacing in headings you may want to take a look at `block.above` instead.
]

==== Book Mode <sec:book-mode>
Let's say you're writing a book, this means that for a reader, there are always two page visible when reading, the _trailing_ (even) and the _leading_ (odd) page.
For left-to-right documents these would correspond to the _left_ and _right_ page respectively, for right-to-left documents this is reversed.

If @cmd:hydra is used on a _leading_ page with #arg(book: true), then it will not show an active element, if it is still visible on the _trailing_ page.
This is turned off by default.

#let book = load-examples("book")
#figure(
  frame(grid(
    columns: 2,
    gutter: 1em,
    show-examples(book.a), show-examples(book.b),
  )),
  caption: [
    Two example documents showing the difference between #arg(book: false) (left) and #arg(book: true) (right).
  ],
)

=== Anchoring <sec:anchor>
To use @cmd:hydra outside of the page header, an @cmd:anchor must be placed, otherwise @cmd:hydra will have problems identifying which elements are where.
@cmd:hydra will always use the last anchor it finds to search, it doesn't have to be inside the header, but should generally be, otherwise the behavior may be unexpected.

#figure(
  ```typst
  #import "@preview/hydra:{{VERSION}}": hydra, anchor
  #set page(header: anchor(), footer: context hydra())
  ```,
  caption: [An example of using @cmd:anchor.],
)

The above example shows how an @cmd:anchor can be used to use @cmd:hydra in the page footer.

=== Custom Elements <sec:custom>
HYDRA is built with custom elements in mind.
Some documents may use other elements for chapters or section-like content.
HYDRA allows defining its own selectors for tight control over how elements are
queried.

Let's say you're using a custom element for chapters by defining a figure with a custom type:
#figure(
  ```typst
  #let chapter = figure.with(kind: "chapter", supplement: [Chapter])
  // ... show rules and additional setup

  #chapter[Introduction]
  #chapter[Main]
  = Section 1.1
  == Subsection 1.1.1
  = Section 1.2
  #chapter[Annex]
  ```,
  caption: [An example document using custom elements.],
)

#info-alert[
  Note that this example is contrived, assuming the user wanted to use a single `=` for sections instead of chapters, they could instead use ```typst #set heading(offset: 1)```.
  This kind of use case was more common before this feature existed.
]

If you now want to to be able to use these custom chapters with @cmd:hydra, you can do so by defining your own @type:hydra-selector:
#figure(
  ```typst
  #import "@preview/hydra:{{VERSION}}": hydra, selectors

  #let chap = figure.where(kind: "chapter")
  #let sect = selectors.custom(heading.where(level: 1), ancestor: chap)

  // Display the chapter on the left and the section on the right.
  #set page(header: context if calc.odd(here().page()) {
    align(left, hydra(chap))
  } else {
    align(right, hydra(sect))
  })
  ```,
  caption: [
    An example of how to use custom #[@type:hydra-selector]s.
  ],
)

The usage of `selectors.custom` allows specifying an element's ancestors, to ensure the scope is correctly defined.
The selectors module also contains some useful default selectors for headings.
