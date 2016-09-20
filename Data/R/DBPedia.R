library(SPARQL)
#Getting number of passengers and coordinates of airports in Germany

query <- "prefix      dbpedia: <http://de.dbpedia.org/resource/> 
prefix  dbpedia-owl: <http://dbpedia.org/ontology/> 
prefix dbpprop-de: <http://de.dbpedia.org/property/>
SELECT DISTINCT  ?name 
                 ?passengers 
                 ?Breitengrad 
                 ?Breitenminute
                 ?Breitensekunde
                 ?Laengengrad 
                 ?Laengenminute
                 ?Laengensekunde
                 ?longitude
                 ?latitude
                 ?city
    WHERE 
    { 
?place              a dbpedia-owl:Airport                              .
?place                       rdfs:label ?name                          .       
?place                 dbpprop-de:passagiere ?passengers               .
OPTIONAL{?place                 dbpprop-de:koordinateBreitengrad  ?Breitengrad     .}
OPTIONAL{?place                 dbpprop-de:koordinateBreitenminute ?Breitenminute .}
OPTIONAL{?place                 dbpprop-de:koordinateBreitensekunde ?Breitensekunde .}
OPTIONAL{?place                 dbpprop-de:koordinateLängengrad ?Längengrad .}
OPTIONAL{?place                 dbpprop-de:koordinateLängenminute ?Längenminute .}
OPTIONAL{?place                 dbpprop-de:koordinateLängensekunde ?Längensekunde .}
OPTIONAL{?place                 geo:long ?longitude .}
OPTIONAL{?place                 geo:lat ?latitude .}

?place                  dbpedia-owl:icaoLocationIdentifier ?icao .
FILTER (?icao LIKE ""ED%"")
}  "
airport<-SPARQL("http://de.dbpedia.org/sparql", query=query)



### Shopping Center

query_shopping <- "prefix      dbpedia: <http://de.dbpedia.org/resource/> 
prefix  dbpedia-owl: <http://dbpedia.org/ontology/> 
prefix dbpprop-de: <http://de.dbpedia.org/property/>

SELECT DISTINCT  ?name
                 ?besucher
                 ?verkaufsflaeche
                 ?longitude
                 ?latitude
                 
WHERE 
{
?place        a dbpedia-owl:wikiPageWikiLink :<http://de.dbpedia.org/page/Einkaufszentrum>
?place                         rdfs:label ?name                 .  
?place                   dbpprop-de:besucher ?besucher        .
?place                    dbpprop-de:verkaufsfläche ?verkaufsflaeche .
OPTIONAL{?place                   dbpprop-de:region  ?region   .}
OPTIONAL{?place                 geo:long ?longitude .}
OPTIONAL{?place                 geo:lat ?latitude .}
}
LIMIT 100 "

#FILTER ( lang(?country) = 'de' and regex(?country, "DE")) 


shopping<-SPARQL("http://de.dbpedia.org/sparql", query=query_shopping)
shopping_df <- data.frame(shopping[1])

query_city <- "
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX : <http://dbpedia.org/resource/>
PREFIX dbpedia2: <http://dbpedia.org/property/>
PREFIX dbpedia: <http://dbpedia.org/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dbo: <http://dbpedia.org/ontology/>

SELECT DISTINCT  ?name 
                 ?area
                 ?population

WHERE 
{
  ?place               rdf:type: City  .
  ?place               rdfs:label ?name .
  ?place            dbo:populationTotal ?population .
  ?place               dbo:areaTotal ?area  .
  OPTIONAL{?place           dbo:populationDensity ?PopDensity .}
  ?place             dbo:country:Germany.
  FILTER ( lang(?name) = 'de' AND ?population > 100000) 

}

"
city<-SPARQL("http://dbpedia.org/sparql", query=query_city)
city_df <- data.frame(city[1])
colnames(city_df) <- c("name", "area", "population")
city_df$popdensity <- city_df$population/(city_df$area/1000000)
