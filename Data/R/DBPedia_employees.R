library(SPARQL)

query <- "PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
prefix dbpedia: <http://de.dbpedia.org/resource/> 
prefix dbpedia-owl: <http://dbpedia.org/ontology/> 
prefix dbpprop-de: <http://de.dbpedia.org/property/>

select distinct 
?name 
?employees
where {
?uni  dbpprop-de:region ?region .
?uni  rdfs:label ?name .
?uni dbpprop-de:mitarbeiterzahl ?employees .
} 
"

#FILTER (lang(?region) ='de' and regex(?region, \"DE-BE\"))

staff<-SPARQL("http://de.dbpedia.org/sparql", query=query)
staff_df <- data.frame(staff[1])
colnames(staff_df) <- c("name", "employees")
staff_df <- subset(staff_df, employees!="%weltweit%" )
staff_df <- subset(staff_df, employees!="%konzernweit%" )
staff_df <- subset(staff_df, employees!="%davon%" )

staff_df$employees <- gsub("([a-zA-Z])","",staff_df$employees)
staff_df$employees <- gsub(" ","",staff_df$employees)
staff_df$employees <- gsub("([ @.â‰ˆ:,<>Ã¼Ÿ()])","",staff_df$employees)
staff_df$employees <- as.numeric(staff_df$employees)


