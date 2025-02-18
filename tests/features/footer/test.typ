/// [max-delta: 1]
///
/// Skipped because of minor floating point differences causing a mismatch.
///
/// Synopsis:
/// - Usage of an anchor ensures query results consistent with those in the
///   header.

#import "/src/lib.typ": hydra, anchor

#set page(
  paper: "a7",
  header: anchor(),
  footer: context hydra(),
)

#include "document.typ"
