#import "custom.typ": chapter, chapter-sel, display-chapter

#set page(header: context (
  none,
  [1 Introduction],
  none,
  [2 Content],
  [2 Content --- 1 First Section],
  [2 Content],
).at(counter(page).get().first() - 1))

#include "document.typ"
