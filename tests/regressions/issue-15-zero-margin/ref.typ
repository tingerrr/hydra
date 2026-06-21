/// Synopsis:
/// - Tracked in #15.
/// - Hydra can properly handle a zero-length margin and does not panic.

#import "/src/lib.typ": hydra

#set page(margin: 0pt, header: context (
  none,
  [1 Introduction],
  none,
  [2.2 Second Section],
).at(counter(page).get().first() - 1))

#include "document.typ"
