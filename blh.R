#Take bloodhound-agents.gz from the Bloodhound website: https://bloodhound-tracker.net/developers
blh = read_csv("bloodhound-agents.csv")

#count number of specimens (based on commas)
blh$coms = gsub("[^,]","",blh$gbifIDs_recordedBy) #this may take a few minutes
blh$n = nchar(blh$coms)+1
#View(count(blh,n))
#select all with more than a 1000 specimens
a_sample = select(filter(blh,n>1000),agents,n)

#remove NA, remove commas
a_sample = filter(a_sample,is.na(agents)==F)
a_sample$coms = gsub("[^,]","",a_sample$agents)

#Remove anything after " -"
#remove anything before a colon
#remove the " -"
a_sample$age = a_sample$agents
a_sample$age = gsub("(?<=\\s\\-).*","",a_sample$age,perl=T)
a_sample$age = gsub(".*[\\:]","",a_sample$age)
a_sample$age = gsub(" -","",a_sample$age,fixed=T)

#inverse names around a comma
a_sample$name = NA
for (i in 1:dim(a_sample)[1]) {
  if (a_sample$coms[i]==",") {
    spl = strsplit(a_sample$age[i],split=",")
    a_sample$name[i] = paste(spl[[1]][2],spl[[1]][1],sep = " ")
  }
}

#take out teams
blh.c = filter(a_sample,grepl("&| and|;",agents)==F)
blh.c = filter(blh.c,nchar(coms)<2)

#merge the inverse and other names
blh.c$fullname = ifelse(is.na(blh.c$name),blh.c$age,blh.c$name)

#remove double spaces and initial spaces
blh.c$fullname = gsub("  "," ",blh.c$fullname,fixed=T)
blh.c$test = substr(blh.c$fullname,1,1)
blh.c$fullname2 = blh.c$fullname
blh.c$fullname2[blh.c$test==" "] = sub(" ","",blh.c$fullname2[blh.c$test==" "])

#generate a full name based on spaces
blh.c$FNAME = NA
blh.c$MNAME = NA
blh.c$LNAME = NA
for (i in 1:dim(blh.c)[1]) {
  splut = strsplit(blh.c$fullname2[i],split=" ")
  if (length(splut[[1]])==2) {
    blh.c$FNAME[i] = splut[[1]][1]
    blh.c$LNAME[i] = splut[[1]][2]
  }
  if (length(splut[[1]])>2) {
    blh.c$FNAME[i] = splut[[1]][1]
    blh.c$MNAME[i] = paste(splut[[1]][2:as.numeric(length(splut[[1]])-1)],collapse=" ")
    blh.c$LNAME[i] = splut[[1]][length(splut[[1]])]
  }
}

#if only a single name, use that as the last name
blh.c$LNAME[is.na(blh.c$LNAME)] = blh.c$fullname2[is.na(blh.c$LNAME)]


#go (use matchName from collectormatching.Rmd)
blh.c$options = NA #possible labels that match
blh.c$lopt = NA #number of matches
blh.c$wdid = NA #to put wikidata item ids
blh.c$score = "" #some sort of indicator how the matching happened

for (i in 1:dim(blh.c)[1]) {
  truem = filter(allb.names,itemLabel==blh.c$fullname2[i])
  if (dim(truem)[1]>0) {
    blh.c$lopt[i] = dim(truem)[1]
    blh.c$score[i] = paste0(blh.c$score[i],"T1")
    blh.c$options[i] = paste(truem$itemLabel,collapse="|")
    blh.c$wdid[i] = paste(truem$id,collapse="|")
    next
  }
  blh.c$score[i] = paste0(blh.c$score[i],"T0")
  blh.c[i,c("lopt","options","wdid")] = matchName(yob,blh.c)
  print(i)
}
