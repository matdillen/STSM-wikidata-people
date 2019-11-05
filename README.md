This repository contains the code and figures that are the main output of the Short Term Scientific Mission I did with [Rod Page](https://github.com/rdmpage) at the University of 
Glasgow in the context of the COST Mobilise action. Some working documents can still be found at https://github.com/matdillen/STSM-mobilise

# Scripts

`collectormatching.Rmd` contains the SPARQL queries, processing of results and a script that attempts automated matching of collector names and dates to these Wikidata items.

`blh.R` tries to apply the same approach (more or less) to the most frequent names available in Bloodhound (https://bloodhound-tracker.net/).

`plotids.R` makes use of GraphViz to plot overlap of different identifiers for the found items in Wikidata. Some example plots can be found in the plots folder.

`properties.R` requests information from the Wikidata REST API for items or properties in batches of 50. It can provide info on labels, claims, references and more.

`publications.R` sets up a large number of SPARQL queries to retrieve publication dates from articles authored by the Wikidata persons retrieved with queries in `collectormatching.Rmd`.
