// Reference: no hydra, the same result as `ref-query-before` but from a
// location-independent query, which all pages can share, filtered afterwards.
#import "/bench/body.typ": body
#set page(paper: "a4", header: context {
  let page = here().page()
  query(heading).filter(h => h.location().page() <= page).len()
})
#body()
