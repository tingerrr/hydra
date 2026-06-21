/// Synopsis:
/// - If a level 2 heading cannot be found, then hydra will not go further than
///   a level 1 heading back, i.e. it respects ancestor boundaries.

#import "/src/lib.typ": hydra

#set page(header: context {
  if calc.even(here().page()) {
    align(left, hydra(1))
  } else {
    align(right, hydra(2))
  }
})

#include "document.typ"
