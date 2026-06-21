/// Synopsis:
/// - Tracked in #5.
/// - If a level 2 heading cannot be found, then hydra will not go further than
///   a level 1 heading back, i.e. it respects ancestor boundaries.

#import "/src/lib.typ": hydra

#set page(header: context (
  none,
  align(left, [1 First Chapter]),
  align(right, [1.1 First Section]),
  none,
  none,
  none,
).at(counter(page).get().first() - 1))

#include "document.typ"
