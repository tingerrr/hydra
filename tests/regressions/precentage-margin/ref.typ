#import "/src/lib.typ": hydra

#set page(header: context (
  [1 Chapter 1],
  [1 Chapter 1],
  [2 Chapter 2],
  [2 Chapter 2],
  [2 Chapter 2],
  [3 Chapter 3],
  [3 Chapter 3],
  [3 Chapter 3],
).at(counter(page).get().first() - 1))

#include "document.typ"
