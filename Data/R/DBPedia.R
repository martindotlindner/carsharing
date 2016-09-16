library(SPARQL)

query <- "prefix      dbpedia: <http://dbpedia.org/resource/> 
prefix  dbpedia-owl: <http://dbpedia.org/ontology/> 
SELECT DISTINCT  ?name 
                 ?Fluggaeste 
                 ?latitude 
                 ?longitude
    WHERE 
    { ?place                    rdfs:label ?name         .
      ?place                     rdf:type  ?Airport                                     .
      ?place                dbp:stat1Data  ?Fluggaeste                                  .
      ?place                      geo:lat  ?latitude                                    .
      ?place                     geo:long  ?longitude                                  .
   FILTER (  ?latitude > 47 
        AND  ?latitude < 56 
        AND ?longitude < 16
        AND ?longitude > 5
        AND LANG(?name) = 'en')
}  "

query <- "prefix      dbpedia: <http://de.dbpedia.org/resource/> 
prefix  dbpedia-owl: <http://dbpedia.org/ontology/> 
prefix dbpprop-de: <http://de.dbpedia.org/property/>
SELECT DISTINCT  ?name 
                 ?Fluggaeste 
                 ?latitude 
                 ?longitude
    WHERE 
    { 
      ?place              a dbpedia-owl:Airport                              .
      ?place                       rdfs:label ?name                          .       
      ?place                 dbpprop-de:passagiere ?passengers               .
      ?place                 dbpprop-de:koordinateBreitengrad  ?latitude     .
      ?place                 dbpprop-de:koordinateLängengrad  ?longitude     .    
}  "





airport<-SPARQL("http://de.dbpedia.org/sparql", query=query)
airport<-SPARQL("http://dbpedia.org/sparql", query=query)

airport_df <- data.frame(airport[1])
airport_df <- unique(airport_df)


### Shopping Center
#Sparql-Code
query_shopping <- "prefix      dbpedia: <http://de.dbpedia.org/resource/> 
prefix  dbpedia-owl: <http://dbpedia.org/ontology/> 
prefix dbpprop-de: <http://de.dbpedia.org/property/>
SELECT ?title ?besucher WHERE {
  ?shopping rdfs:label  ?title   .
  ?shopping a owl:Thing            .
  ?shopping  dbpprop-de:besucher  ?besucher            .                               
} 
"

shopping<-SPARQL("http://de.dbpedia.org/sparql", query=query_shopping)
shopping_df <- data.frame(shopping[1])
