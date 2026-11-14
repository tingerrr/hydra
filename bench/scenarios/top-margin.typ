// Only the top margin calculation in the header.
#import "/bench/body.typ": body
#import "/src/lib.typ": core
#set page(paper: "a4", header: context core.get-top-margin())
#body()
