// A single second-level hydra call, scoped by its level-1 ancestors.
#import "/bench/body.typ": body
#import "/src/lib.typ": hydra
#set page(paper: "a4", header: context hydra(2))
#body()
