library(WikipediR)
library(RCurl)
library(XML)
library(RJSONIO)

wikidata <- page_content(language = "de", project = "wikipedia", page_name = "Berlin",  as_wikitext = TRUE)
wikidata$parse$wikitext$`*`

regmatches(wikidata$parse$wikitext$`*`, regexpr('Bevölkerungsdichte.+?Einwohner', wikidata$parse$wikitext$`*`))


