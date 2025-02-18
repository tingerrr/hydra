#import "/src/lib.typ": hydra

#set page(
  paper: "a7",
  header: context (
    none,
    none,
    [1.3 Third Section],
    [3.1 Final Section],
  ).at(counter(page).get().first() - 1),
)

#include "document.typ"
