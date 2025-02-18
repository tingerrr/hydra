/// Synopsis:
/// - When a page starts with a primary element and `skip-starting` is set to
///   `false`, then the element on this page is displayed.

#import "/src/lib.typ": hydra

#set page(
  paper: "a7",
  header: context hydra(skip-starting: false, 2),
)

#include "document.typ"
