/// Synopsis:
/// - When there are multiple candidates on a page, hydra still shows the last
///   primary candidate even in the presence of ancestors.

#import "/src/lib.typ": hydra

#set page(paper: "a7", header: context hydra(use-last: true, 2))

#include "document.typ"
