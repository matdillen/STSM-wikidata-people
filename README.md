This repository contains the code and figures that are the main output of the Short Term Scientific Mission I did with [Rod Page](https://github.com/rdmpage) at the University of 
Glasgow in the context of the COST Mobilise action. Some working documents can still be found at https://github.com/matdillen/STSM-mobilise

# Scripts

`collectormatching.Rmd` contains the SPARQL queries, processing of results and a script that attempts automated matching of collector names and dates to these Wikidata items.

`blh.R` tries to apply the same approach (more or less) to the most frequent names available in Bloodhound (https://bloodhound-tracker.net/).

`plotids.R` makes use of GraphViz to plot overlap of different identifiers for the found items in Wikidata. Some example plots can be found in the plots folder.

`properties.R` requests information from the Wikidata REST API for items or properties in batches of 50. It can provide info on labels, claims, references and more.

`publications.R` sets up a large number of SPARQL queries to retrieve publication dates from articles authored by the Wikidata persons retrieved with queries in `collectormatching.Rmd`.

# Data

As part of this work, a series of SPARQL queries was performed in early October 2019 to list all possible Wikidata properties present in the set of Wikidata person records assembled with the SPARQL queries from `collectormatching.Rmd` and connected to specimen records from MeiseBG using the matching process of that R script. All properties are listed in `data/wikidataids.tsv` along with their frequency. The same list can still be found in a google sheet [here](https://docs.google.com/spreadsheets/d/175ya1JEoR1sb6Mqd74EKucC-vrm0BEvzYvCuG0IitzI/).

# Methodology
A more detailed description of this work can be found in the [5.4 deliverable report](https://doi.org/10.34960/ajxs-zr25) from the DiSSCo Prepare project. [Alternate link](https://www.dissco.eu/wp-content/uploads/DiSSCo-Prepare-D5.4-Semantic-Enhancement-w-doi.pdf).
