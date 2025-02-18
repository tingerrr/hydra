#import "/docs/manual/util.typ": mantys
#import mantys: *

== Introduction
HYDRA is a package which currently provides a single function with the same name @cmd:hydra.
This function can be used to query and display section elements, such as headings,legal paragraphs, documentation sections, and whatever else may semantically declare the start of a document's parts.
This is most commonly used inside the header of a document, such that a reader always has a good idea where they are when flipping through pages.

Here's an example of how @cmd:hydra can be used:
#codesnippet[
  ```typst
  // Show the current chapter in the header, but not on chapter title pages.
  #set page(header: context hydra(1))
  ```
]

The following sections explain some core concepts and go over some features, when they are useful and how you can enable/disable them.

=== Terminology
The remainder of this document assumes that you are familiar with some of HYDRA's various terms.
There's no need to read the definitions now, but you can come back here when you encounter one of those terms.

// TODO(tinger): add these to the index using `idx`, see
// https://github.com/jneug/typst-mantys/issues/28
/ _element_:
  Refers to any type of content that you may use as a section marker, these are most commonly headings, but depending on your use case may also be other elements.

/ _primary element_: #idx("primary element")
  An _element_ which is primarily looked for and meant to be displayed.

/ _ancestor element_: #idx("ancestor element")
  An _element_ which is the immediate or transitive ancestor to the _primary element_.
  A level 3 heading is an ancestor to both level 2 (directly) and level 1 headings (transitively).

/ _scope_: #idx("scope")
  The scope refers to the part of a document which is between the closest ancestors of a primary element.

/ _active element_: #idx("active element")
  The active element refers to whatever element is considered for display.
  While this is usually the previous primary element, it may sometimes be the next primary element.

=== Scoping
Scoping is the primary mechanism with which @cmd:hydra determines which elements to display.
The search for a primary element is always bounded to its scope, if no primary element is found within a scope, then none is displayed.
Consider the following contrived document:

#codesnippet[
  ```typst
  = Chapter 1
  == Section 1.1

  = Chapter 2
  === Subsection 2.0.1
  #hydra(2)
  ```
]
#codesnippet[
  ```txt
  Chapter 1
  └ Section 1.1
  Chapter 2
  └ <none>
    └ Subsection 2.0.1
  ```
]

Here, @cmd:hydra is used with `2` as its selector argument, this means it shoudl look for level 2 headings, let's call them sections, with level 1 headings being chapters.
Because of this, @cmd:hydra will only search within the current chapter, displaying Section 1.1 would simply be wrong there.
This is the _scope_, it's given by the relationship of the primary element (sections) and the ancestor elements (chapters).
Therefore, @cmd:hydra would not find any suitable candidate to display and will not display anything.
