/// Synopsis:
/// - The smallest page should only be used for the `2.5 / 21` fallback.

#import "/src/lib.typ": hydra

#set page(header: context hydra(
  1,
  skip-starting: false,
))

#include "document.typ"
