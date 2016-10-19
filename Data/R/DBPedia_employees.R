library(SPARQL)

setwd("C:/Program Files/PostgreSQL/9.5/data/")


wiki_geocode <- read.table("Wiki_Geocode_DE.csv",header = TRUE, sep = ";")

query_staff <- enc2utf8("
prefix  dbpedia-owl: <http://dbpedia.org/ontology/>
prefix dbpprop-de: <http://de.dbpedia.org/property/>
                  
SELECT DISTINCT   ?name
                  ?PageID
                  ?staff
                  ?lat
                  ?long
                  ?laenge
                  ?breite
WHERE {
      ?place              rdf:type:dbpedia-owl: University .
      ?place               rdfs:label ?name   .  
      ?place              dbpedia-owl:wikiPageID ?PageID .
      ?place        dbpedia-owl:staff ?staff  .
      Optional {  ?place      geo:lat   ?lat    . }
      Optional {  ?place      geo:long  ?long   . }
      Optional {  ?place      dbpprop-de:längengrad  ?laenge   . }  
      Optional {  ?place      dbpprop-de:breitengrad  ?breite   . }  
      }
")


query_mitarbeiter1 <- enc2utf8("
                               prefix  dbpedia-owl: <http://dbpedia.org/ontology/>
                               prefix dbpprop-de: <http://de.dbpedia.org/property/>
                               
                               SELECT DISTINCT   ?name
                               ?PageID
                               ?staff
                               ?lat
                               ?long
                               ?laenge
                               ?breite
                               WHERE {
                               ?place               rdfs:label ?name   .  
                               ?place              dbpedia-owl:wikiPageID ?PageID .
                               ?place        dbpprop-de:mitarbeiterzahl ?staff  .
                               Optional {  ?place      geo:lat   ?lat    . }
                               Optional {  ?place      geo:long  ?long   . }
                               Optional {  ?place      dbpprop-de:längengrad  ?laenge   . }  
                               Optional {  ?place      dbpprop-de:breitengrad  ?breite   . }  
                               }
                               ")

query_mitarbeiter2 <- enc2utf8("
prefix  dbpedia-owl: <http://dbpedia.org/ontology/>
                        prefix dbpprop-de: <http://de.dbpedia.org/property/>
                        
                        SELECT DISTINCT   ?name
                        ?PageID
                        ?staff
                        ?lat
                        ?long
                        ?laenge
                        ?breite
                        WHERE {
                        ?place               rdfs:label ?name   .  
                        ?place              dbpedia-owl:wikiPageID ?PageID .
                        ?place        dbpprop-de:mitarbeiterzahl ?staff  .
                        Optional {  ?place      geo:lat   ?lat    . }
                        Optional {  ?place      geo:long  ?long   . }
                        Optional {  ?place      dbpprop-de:längengrad  ?laenge   . }  
                        Optional {  ?place      dbpprop-de:breitengrad  ?breite   . }  
                        }
LIMIT 10000 OFFSET 10000
                        ")

endpoint <- "http://de.dbpedia.org/sparql"

staff<-SPARQL("http://de.dbpedia.org/sparql", query=query_staff)
staff_df <- data.frame(staff[1])

mitarbeiter1<-SPARQL("http://de.dbpedia.org/sparql", query=query_mitarbeiter1)
mitarbeiter_df1 <- data.frame(mitarbeiter1[1])

mitarbeiter2<-SPARQL("http://de.dbpedia.org/sparql", query=query_mitarbeiter2)
mitarbeiter_df2 <- data.frame(mitarbeiter2[1])

mitarbeiter_df <- rbind(mitarbeiter_df1,mitarbeiter_df2)

colnames(mitarbeiter_df) <- c("name", "page_id","staff","latitude","longitude","länge","breite")


mitarbeiter_geocode <- merge(mitarbeiter_df,wiki_geocode)



mitarbeiter_gecode <- subset(mitarbeiter_gecode, staff!="%weltweit%" )
mitarbeiter_gecode <- subset(mitarbeiter_gecode, staff!="%konzernweit%" )
mitarbeiter_gecode <- subset(mitarbeiter_geocode, staff!="%davon%" )

staff_df$employees <- gsub("([a-zA-Z])","",staff_df$employees)
staff_df$employees <- gsub(" ","",staff_df$employees)
staff_df$employees <- gsub("([ @.â‰ˆ:,<>Ã¼Ÿ()])","",staff_df$employees)
staff_df$employees <- as.numeric(staff_df$employees)

