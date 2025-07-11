#import "/src/lib.typ": hydra

#set page(paper: "a7", header: context (
  none,
  [1.1 First Section],
  [1.2 Second Section],
  none,
).at(counter(page).get().first() - 1))

#include "document.typ"
