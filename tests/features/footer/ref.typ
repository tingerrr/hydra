#import "/src/lib.typ": hydra

#set page(
  paper: "a7",
  footer: context (
    none,
    [1 Introduction],
    [1 Introduction],
    none,
    none,
    [2.2 Second Section],
  ).at(counter(page).get().first() - 1),
)

#include "document.typ"
