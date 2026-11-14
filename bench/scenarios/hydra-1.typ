// A single top-level hydra call, no ancestors involved.
#import "/bench/body.typ": body
#import "/src/lib.typ": hydra
#set page(paper: "a4", header: context hydra(1))
#body()
