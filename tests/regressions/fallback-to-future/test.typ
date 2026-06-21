/// Synopsis:
/// - Not tracked.
/// - When both last and prev candidates are none, hydra should not fall back to
///   a candidate defined on a future page. Candidates defined after the current
///   page should never be displayed.

#import "/src/lib.typ": hydra

#set page(header: context hydra())

#include "document.typ"
