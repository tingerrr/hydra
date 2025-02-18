/// Synopsis:
/// - If `use-last` is set to `true`, hydra considers the current page to be
///   part of the search scope, including the last primary element on this page.

#import "/src/lib.typ": hydra

#set page(
  paper: "a7",
  header: context hydra(use-last: true),
)

#include "document.typ"
