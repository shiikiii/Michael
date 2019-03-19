
// ************************** \\
// ******* QUESTION 1 ******* \\
// **************************** \\
// Return the movie titled “The Green Mile” 
// (label:Movie, title:"The Green Mile")

match (m:Movie{title: "The Green Mile"})
return m //select SQL, $project mongodb


// General syntax
// match (variable:Label {propertyKey: propertyValue, propertyKey2: propertyValue2})
// return variable


// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 2 ******* \\
// **************************** \\
// Return the released year of the movie "The Matrix"
// (label:Movie, key:released)

match (m:Movie{title: "The Matrix"})
return m.released

// ALIAS
match (m:Movie{title: "The Matrix"})
return m.released as `year released`


// 
// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 3 ******* \\
// **************************** \\
// Return the list of names of people who acted 
// in the “A Few Good Men”

match (p:Person)-[:ACTED_IN]->(:Movie{title:"A Few Good Men"})
return p.name

// no undirected relationships in Neo4j and it plays a role
// in the data returned

match (p:Person)-[rel]->(:Movie {title:"The Matrix"})
return p.name, type(rel)


// Directions matter

match (p1:Person)-[:FOLLOWS]-(p2:Person {name: "Angela Scope"})

match (p1:Person)-[:FOLLOWS]->(p2:Person {name: "Angela Scope"})
return p1
// Paul

match (p1:Person)<-[:FOLLOWS]-(p2:Person {name: "Angela Scope"})
return p1
// Jessica

// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 4 ******* \\
// **************************** \\
// Return the producers' names (label:Person) as 
// name and (key:tagline) tagline of the movie 
// titled (key:title) "Ninja Assassin" (label:Movie)


match (p:Person)-[:PRODUCED]->(m:Movie {title:"Ninja Assassin"})
return m.tagline, p.name as name






// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 5 ******* \\
// **************************** \\
// Find all the people who acted or directed (rel: ACTED_IN, DIRECTED) 
// “The Polar Express”.
// Return names (key:name) and relationship type.

match (p:Person)-[r:ACTED_IN|DIRECTED]->(m:Movie{title:"The Polar Express"})
return p.name, type(r)

// GET lables
labels(p)


// Get all properties
match (n)
return keys(n)




// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 6 ******* \\
// **************************** \\
// Find all the people who acted in the same movie that 
// he or she directed. Return their names and movie titles










// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 7 ******* \\
// **************************** \\
// Find all the coactors of Tom Hanks. First return all coactors. 
// Return only coactor names














// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 8 ******* \\
// **************************** \\
// Find all the people who directed the movie he or she
// also wrote. Sort by movie title descending and
// rename the column with the director/writer names as
// name and movie titles as title. 












// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 9 ******* \\
// **************************** \\
// Find all the movies released only in the nineties, where the movie
// title comes after the letter P and an actor in it is born after the 1970s.













// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 10 ******* \\
// **************************** \\
// Find all the movies released in the nineties i.e. after 1989 and before 2000. Limit to 3.













// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 11 ******* \\
// **************************** \\
// Return the actors name, movie title and movie released date (key:name, title, released) of the movies
// released between 2003 and 2004














// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 12 ******* \\
// **************************** \\
// Find all the movies that contain the word "the" in the title and return only the title.




















// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 13 ******* \\
// **************************** \\
// Find all the actors in movies which starts with "Top" in the title.
// Return movie title as Movies, and actor names as Names
















// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 14 ******* \\
// **************************** \\
// Show all movies excluding the Matrix movies and return the title of 
// those movies as Movie, and the name of the actors as Name. Order by 
// movie title descending












// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 15 ******* \\
// **************************** \\
// Find all the movies Tom Hanks only acted in but did not
// write, produce or direct














// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 16 ******* \\
// **************************** \\
// Find all the movies written by people who did not direct (rel:DIRECTED) that movie. Return the person's name
// and movie title.












// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 17 ******* \\
// **************************** \\
// Find movies that the Gene Hackman acted in with another person that both acted in that movie
// as well as directed it. Return both people and the movie.












// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 18 ******* \\
// **************************** \\
// Find movies all the movies where an person1 acted in a movie and person2 (label:Person) both produced
// and directed that movie. Return the person's name, the other persons











// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 19 ******* \\
// **************************** \\
// Find all the people who were born in 1965 or 1970















// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 20 ******* \\
// **************************** \\

// Find all the movies where Matrix is in the title (k:title, :Movie) and
// return the name of the person (key:name, :Person) who played the role of Neo (key: roles, relationship ACTED_IN).
// Return the movie title as Movie, the person name as Name and the role as Role 





