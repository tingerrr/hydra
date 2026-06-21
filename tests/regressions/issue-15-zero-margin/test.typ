/// Synopsis:
/// - Hydra can properly handle a zero-length margin and does not panic.

#import "/src/lib.typ": hydra

#set page(margin: 0pt, header: context hydra())

#include "document.typ"
