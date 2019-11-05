library(httr)
library(tidyverse)

resu.r = list()
j=1

#assess is the list of wikidata items which were matched to the MeiseBG collector list
#any filter of the SPARQL query results could do
#only item ids (not URLs) and labels are needed
steps = seq(1,dim(assess)[1],by=49)
steps = c(steps,dim(assess)[1])
for (i in steps[-length(steps)]) {
  tst = paste(assess$id[i:steps[j+1]],
              collapse="|")
  resu = httr::GET(url = paste0("https://www.wikidata.org/w/api.php?action=wbgetentities&ids=",
                                tst,
                                "&format=json"),
                   httr::user_agent("insert_your_wiki_name_here_please"))
  resu.r[[j]] = httr::content(resu,type="application/json")
  print(j)
  j=j+1
}

#list label languages
assess2 = select(assess,id,itemLabel)
assess2$labelLangs = NA
j=1
for (i in 1:dim(assess2)[1]) {
  assess2$labelLangs[i] = paste(names(resu.r[[j]]$entities[[assess2$id[i]]]$labels),
                                collapse="|")
  if(i%%49==0) {
    j=j+1
  }
}

#indicate gender
assess2$gender = NA
j=1
for (i in 1:dim(assess2)[1]) {
  try(assess2$gender[i] <- resu.r[[j]]$entities[[assess2$id[i]]]$claims$P21[[1]]$mainsnak$datavalue$value$id,
      silent=T)
  if(i%%49==0) {
    j=j+1
  }
}

#and country
assess2$country = NA
j=1
for (i in 1:dim(assess2)[1]) {
  try(assess2$country[i] <- resu.r[[j]]$entities[[assess2$id[i]]]$claims$P27[[1]]$mainsnak$datavalue$value$id,
      silent=T)
  if(i%%49==0) {
    j=j+1
  }
}

#stack all listed property ids
j=1
props = names(resu.r[[1]]$entities[[assess2$id[1]]]$claims)
for (i in 2:dim(assess2)[1]) {
  props = c(props,names(resu.r[[j]]$entities[[assess2$id[i]]]$claims))
  if(i%%49==0) {
    j=j+1
  }
}

#make frequency table
props=tibble(props)
props2 = count(props,props)

#retrieve data on all these properties
props.r = list()
j=1
steps = seq(1,dim(props2)[1],by=49)
steps = c(steps,dim(props2)[1])
for (i in steps[-length(steps)]) {
  tstp = paste(props2$props[i:steps[j+1]],collapse="|")
  propu = httr::GET(url = paste0("https://www.wikidata.org/w/api.php?action=wbgetentities&props=labels&ids=",
                                 tstp,
                                 "&format=json"),
                    httr::user_agent("Matdillen"))
  props.r[[j]] = httr::content(propu,
                               type="application/json")
  print(j)
  j=j+1
}

#extract english label to find out what these properties all are
props2$label = NA
j=1
for (i in 1:dim(props2)[1]) {
  props2$label[i] = props.r[[j]]$entities[[props2$props[i]]]$labels$en$value
  if(i%%49==0) {
    j=j+1
  }
}