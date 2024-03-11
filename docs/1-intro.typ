Hydra is a package which aims to query and display section elements, such as headings, legal
paragraphs, documentation sections, and whatever else may semantically declare the start of a
document's section.

== Terminology & Semantics
The following terms are frequently used in the remainider of this document.

/ primary: The element which is primarily looked for and meant to be displayed.
/ ancestor: An element which is the immediate or transitive ancestor to the primary element.
  A level 3 heading is ancestor to both level 2 (directly) and level 1 headings (transitively).
/ scope: The scope of a primary element refers to the section of a document which is between the
  closest ancestors.
/ active: The active element refers to whatever element is considered for display. While this is
  usually the previous primary element, it may sometimes be the next primary element.
/ leading page: A leading page in a book is that, which is further along the content of the two
  visible pages at any time, this is the `end` alignement with respect to the document readin
  direction.
/ trailing page: A trailing page is that, which is not the leading page in a book.

The search for a primary element is always bounded to it's scope. For the following simplified
document:

```typst
= Chapter 1
== Section 1.1

= Chapter 2
=== Subsection 2.0.1
#hydra(2)
```
```txt
Chapter 1
└ Section 1.1
Chapter 2
└ <none>
  └ Subsection 2.0.1
```

hydra will only search within it's current chapter as it is looking for active sections. In this
case hydra would not find a suitable candidate. For this the ancestors of an element must be known.
For headings this is simple:
#align(center, (
  `<none>`,
  `level: 1`,
  `level: 2`,
  `level: 3`,
  `...`,
).join([ #sym.arrow ]))

If hydra is used to query for level 2 headings it will only do so within the bounds of the closest
level 1 headings. In principle, elements other than headings can be used (see @custom), as long as
their semantic relationships are established.
