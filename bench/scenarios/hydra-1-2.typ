// The typical header setup, this is the one that scales quadratically.
#import "/bench/body.typ": body
#import "/src/lib.typ": hydra
#set page(paper: "a4", header: context {
  hydra(1)
  h(1fr)
  hydra(2)
})
#body()
