// Reference: no hydra, a single location-dependent query per page. The selector
// differs on every page, so no two pages can share a memoized query result.
#import "/bench/body.typ": body
#set page(paper: "a4", header: context query(selector(heading).before(here())).len())
#body()
