library(SPARQL)
setwd("C:/Program Files/PostgreSQL/9.5/data/")

wiki_geocode <- read.table("Wiki_Geocode_DE.csv",header = TRUE, sep = ";",fileEncoding = "utf8")

query_university <- enc2utf8("
prefix  dbpedia-owl: <http://dbpedia.org/ontology/>
  prefix dbpprop-de: <http://de.dbpedia.org/property/>
  PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>


SELECT DISTINCT   ?name
?PageID
?staff
?students
WHERE {
  ?place              rdf:type ?type .
  ?place               rdfs:label ?name   .  
  ?place              dbpedia-owl:wikiPageID ?PageID .
  ?place         dbpedia-owl:staff  ?staff  .
  ?place         dbpedia-owl:numberOfStudents ?students
}
")

endpoint <- "http://de.dbpedia.org/sparql"

university <-SPARQL("http://de.dbpedia.org/sparql", query=query_university)
university_df <- data.frame(university[1])


colnames(university_df) <- c("name", "page_id","staff")


university_geocode <- merge(university_df,wiki_geocode)
university_geocode$name <- NULL
university_geocode$titel <- as.character(university_geocode$titel)
write.table(university_geocode,
            "C:/Users/Martin/Documents/Workaholic/TUD_Verkehr/Geodaten/Wikipedia/University_Geocode.csv",
            fileEncoding = "utf8",sep = ";",row.names = FALSE)
