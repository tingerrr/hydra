#set page(header: context (
  none,
  none,
  none,
  [2.1 First Section],
  none,
  [2.2 Second Section],
).at(counter(page).get().first() - 1))

#include "document.typ"
