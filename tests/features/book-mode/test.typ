/// Synopsis:
/// - On even pages the prev candidate is not displayed as it is still visible.
/// - On odd pages the prev candidate is displaed as it is not visible.

#import "/src/lib.typ": hydra

#set page(
  paper: "a7",
  header: context hydra(book: true),
)

#include "document.typ"
