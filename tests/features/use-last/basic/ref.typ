#import "/src/lib.typ": hydra

#set page(
  paper: "a7",
  header: context (
    none,
    [1 Introduction],
    [1 Introduction],
    none,
    none,
    [2.3 Third Section],
    [2.3 Third Section],
  ).at(counter(page).get().first() - 1),
)

#include "document.typ"
