#import "/src/lib.typ": hydra

#set page(header: context (
  none,
  none,
  none,
  [1 Introduction],
).at(counter(page).get().first() - 1))

#include "document.typ"
