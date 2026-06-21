/// Synopsis:
/// - The figure doesn't interfere with chapter numbering.
/// - The use of `custom` ensures that heading searches are scoped by chapters.

#import "custom.typ": chapter, chapter-sel, display-chapter

#import "/src/lib.typ" as hydra
#import hydra.selectors: custom
#import hydra: hydra

#set page(header: context {
  let chap = hydra(chapter-sel, display: display-chapter)
  let sec = hydra(custom(heading.where(level: 1), ancestors: chapter-sel))

  chap
  if chap != none and sec != none [ --- ]
  sec
})

#include "document.typ"
