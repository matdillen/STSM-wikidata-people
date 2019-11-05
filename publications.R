library(tidyverse)

#initialize
pubst = tibble(item = 0,itemLabel = 0, pub = 0,id=0)

#modify iterator range to apply multiple batches
#allb.nd is the result of the joined queries, filter for items without any date
#take querki function from authormatching.R
for (i in 40001:52582) {
  query <- paste0('SELECT ?item ?itemLabel ?pub WHERE 
  {
  ?item wdt:P50 wd:',allb.nd$id[i],'.
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" }
  OPTIONAL { ?item wdt:P577 ?pub.}
  }')
  pubs = querki(query)
  if (dim(pubs)[1]>0) {
    pubs$id = allb.nd$id[i]
    pubst = rbind(pubst,pubs)
  }
  print(i)
}

#post processing
pubst.uni = filter(pubst,duplicated(id)==F)
pubst.uni = pubst.uni[-1,] #initial row
pubst2 = pubst
pubst2$year = substr(pubst2$pub,1,4)
pubst2 = pubst2[-1,]

for (i in 1:dim(pubst.uni)[1]) {
  giv = filter(pubst2,id==pubst.uni$id[i])
  pubst.uni$mndate[i] = min(giv$year)
  pubst.uni$mxdate[i] = max(giv$year)
}