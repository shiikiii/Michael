
// ************************** \\
// ******* REVIEW QUESTIONS  ******* \\
// **************************** \\


// 1 - Return the name (label:Person, key: name) 
// of all the people who have reviewed movies (label:Movie)

match (p:Person)-[:REVIEWED]->(:Movie)
return distinct p.name




// 2 - Return the types of relationships that Danny DeVito 
// has to movies and these movies' titles.
// If you were to write this as a simple MongoDB query 
// (no Aggregation), assume the following:

match (p:Person {name: "Danny DeVito"})-[r]->(m:Movie)
return type(r), m.title

// Person Collection
// name: String,
// movies: [{title: String, relationship: "ACTED_IN"},{title: String, relationship: Director}]


db.person.find({name:"Danny DeVito"},{_id:0, "movies.title":1, "movies.relationship":1})






// 3 - Find the movies that Clint Eastwood has either ACTED_IN 
// or DIRECTED. Return their titles


match (p:Person {name: "Clint Eastwood"})-[r:ACTED_IN|DIRECTED]->(m:Movie)
return m.title






// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 1 ******* \\
// **************************** \\
// Find all the people who acted in the same movie that 
// he or she directed. Return their names and movie titles

match (p:Person)-[:ACTED_IN]-(m:Movie)-[:DIRECTED]-(p)
return p.name, m.title

match (p:Person)-[:ACTED_IN]->(m:Movie),(p)-[:DIRECTED]->(m)
return p.name, m.title


match (n:Person{name:"Keanu Reeves"})-[:HAS_CONTACT]-()
match (f)-[:HAS_CONTACT]->(contact2)
return contact2.name
limit 5

// F definitely has contact with Keanu Reeves
// who does f have contact with


// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 2 ******* \\
// **************************** \\
// Find all the coactors of Jack Nicholson. 
// First return all coactors. 
// Return only coactor names

// ORDER BY - desc, default: asc
// DISTINCT
match (p:Person )-[:ACTED_IN]->(m:Movie)<-[:ACTED_IN]-(p2:Person {name:"Jack Nicholson"})
return p.name 
order by p.name












// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 3 ******* \\
// **************************** \\
// Find all the people who directed the movie he or she
// also wrote. Sort by movie title ascending, limit to 3, and
// rename the column with the director/writer names as
// name and movie titles as title. 


match (p:Person)-[:DIRECTED]->(m:Movie)<-[:WROTE]-(p)
return p.name as name, m.title as title
order by title
limit 3









// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 4 ******* \\
// **************************** \\
// Find all the movies released only in the nineties, 
// where the movie
// title comes after the letter P and an actor in it is born 
// after the 1970s.

// WHERE clause - filters what gets returned

// SIMPLE Case:
match (p:Person)-[:ACTED_IN]->(m:Movie {title:"The Matrix"})
return p.name

match (p:Person)-[:ACTED_IN]->(m:Movie)
where m.title ="The Matrix"
return p.name

match (p:Person)-[:ACTED_IN]->(m:Movie)
where m.title ="The Matrix" or m.title = "Top Gun"
return p.name


// Find all movies released (m.released) in 1992 and return the title
// order by desc, limit 3.

match (m:Movie)
where m.released = 1992
return m.title
order by m.title desc 
limit 3







// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 5 ******* \\
// **************************** \\
// Find all the movies released in the nineties i.e. 
// after 1989 and before 2000. Limit to 3.


// .find({ $and: [{$lt}, {$gt}]})
// .find({{field: $lt{}, field: $gt{}}]})

match (m:Movie)
where 1989 < m.released <2000
return m.title
order by m.title
limit 3

match (m:Movie)
where m.released >1989 and m.released <2000
return m.title
order by m.title
limit 3








// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 6 ******* \\
// **************************** \\
// Return the actors name, movie title and movie released 
// date (key:name, title, released) of the movies
// released between 2003 and 2004 and the movie title is 
// "Something's Gotta Give".


match (p:Person)-[:ACTED_IN]->(m:Movie) 
where m.released >= 2003 and m.released <=2004 and m.title="Something's Gotta Give" 
return p.name, m.title, m.released













// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 7 ******* \\
// **************************** \\
// Find all the movies that contain the word "the" in the 
// title and return only the title.



// STRING Operators
// starts with, contains, ends with

match (m:Movie)
where toLower(m.title) contains "the"
return m.title


// string operators are CASE SENSITIVE











// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 8 ******* \\
// **************************** \\
// Find all the actors in movies that start with "Jo" in the title.
// Return movie title as Movie Titles, and actor names as Actor Names


match (p:Person)-[:ACTED_IN]->(m:Movie)
where m.title starts with "Jo"
return m.title as `Movie Title`, p.name as `Actor Names`














// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 9 ******* \\
// **************************** \\
// Find all movies that dont include "Matrix" in the title, 
// and where the movies
// were released in either 1999 or 2003. Return the title of 
// those movies as Movie, the name of the actors as Name.
// Order by movie title descending


// IN operator
// in [val1, val2]

// NOT
// NOT <condition1>
// where not m.released=1970


match (m:Movie)<-[:ACTED_IN]-(p:Person)
where not m.title contains "Matrix" and m.released in [1999, 2003]
return m.title as Movie, p.name as Name, m.released
order by Movie desc




// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 10 ******* \\
// **************************** \\
// Find all the movies Tom Hanks only acted in but did not
// direct (:DIRECTED) and were released in 2004 or 2006. Return the 
// movie title and movie released year (key:released) as year

match (p:Person{name: "Tom Hanks"})-[:ACTED_IN]->(m:Movie)
where not (p)-[:DIRECTED]->(m) and m.released IN [2004,2006]
return m.title, m.released as year







// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 11 ******* \\
// **************************** \\
// Find all the movies where an actor played the role of 
// "Neo" (:ACTED_IN, key:roles, array)
// and the movie was released in 2003.

// IN for arrays

match (p:Person)-[r:ACTED_IN]->(m:Movie)
where "Neo" in r.roles AND m.released = 2003
return p, m










// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 12 ******* \\
// **************************** \\
// Find movies where the actor played the role of 
// Little Bill Dagget (:ACTED_IN, key:roles) with another 
// person that both acted in that movie
// as well as directed it. Return both people and the movie.


match (p:Person)-[r:ACTED_IN]->(m:Movie), (p2:Person)-[:ACTED_IN]->(m),
(p2)-[:DIRECTED]->(m)
where "Little Bill Daggett" in r.roles
return p, p2, m













// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 13 ******* \\
// **************************** \\
// Find  all the movies where a person1 acted in a movie and 
// another person (label:Person) both produced
// and directed that movie. Return the person's name, the other
//  persons name.

match (p:Person)-[:ACTED_IN]->(m:Movie)<-[:PRODUCED]-(p2:Person)
where (p2)-[:DIRECTED]->(m)
return p2.name, p.name, m.title


//  compare to:
match (p:Person)-[:ACTED_IN]->(m:Movie)<-[:PRODUCED]-(p2:Person)
where (p2)-[:DIRECTED]->()
return p2.name, p.name, m.title 









// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 14 ******* \\
// **************************** \\
// Find all of Tom Hanks coactors who were born after the 1969 but before 1976 and 
// have earned more than $5,000,000 in a film. Return actor name and earnings.




match (p:Person {name: "Tom Hanks"})-[:ACTED_IN]->(m), (c:Person)-[r:ACTED_IN]->(m)
where 1970 < c.born <1976 and r.earnings > 5000000
return c as Actor, r.earnings as Earnings











// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 15 ******* \\
// **************************** \\
// Find all actors and return their name, number of movies they have acted in as MovieCount, 
// sum of their earnings as Total, minimum earnings as Min, maximum earnings as Max, and average earnings as Avg. 
// Collect all the movies by title (only) they acted in, actor earnings and sort by MovieCount from greatest to smallest.


















// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 16 ******* \\
// **************************** \\
// Count the number of paths found for each
// actor/director pair to a movie and order by the count descending.
// Rename the count as Collaborations and order by














// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 17 ******* \\
// **************************** \\
//  Group all Person nodes by the type of relationship
// it has to a movie, and return the count per
// relationship type. Rename the count as relCount and 
// order by descending.














// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 18 ******* \\
// **************************** \\
// By movie year released, find the total cost of the actors for the movies of that year. 
// Order by year.Return the year, total cost as Cost, and the movie titles for that year.















// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 19 ******* \\
// **************************** \\
// Find all actors where there total earnings is greater than $60M and only 
// return their name and total earnings (:ACTED_IN, key:earnings). Sort by total earnings. Use the WITH clause
















// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 20 ******* \\
// **************************** \\
// By number of movies, group actors who acted in more than 4 movies and return the 
// total earnings as well as average earnings for that grouping. 
















// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 21 ******* \\
// **************************** \\
// group by number of roles played greater than 1
// By number of movies, group actors who acted in more than 4 movies and return the 
// total earnings as well as average earnings for that grouping. 















// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 22 ******* \\
// **************************** \\
// Suggest new writers to directors (lets call them, D1 directors) via other people that these directors (D1) have contact with
// that have also directed movies. Make sure these set of writers have never worked with those directors (D1). Return the grouping
// by the first group of directors (D1), the writers that directors (D1) has worked with as "worked with writers", and the new suggested
// writers as "suggested writers" and limit to 3.













// ---------------------------------------------------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------------------------------------------------
//****** VARIABLE LENGTH PATH ******\\


// ************************** \\
// ******* QUESTION 22 ******* \\
// **************************** \\
// Find all the nodes 2 :HAS_CONTACT nodes away from Tom Hanks who have acted in a movie, 
// where that person is not Tom Hanks. Find the size of that group of people who have acted
// in those movies and return that size.















// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 23 ******* \\
// **************************** \\
// Find all the nodes that Tom Hanks is 2 :HAS_CONTACT node hops away from and where these nodes have acted in a movie that
// Tom Hanks has not acted in that same movie.














// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 24 ******* \\
// **************************** \\
// Find a path from Nora Ephron via :DIRECTED or :PRODUCED relationship that is no more than 3
// node hops away


















// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 25 ******* \\
// **************************** \\
// What's the shortest path between Joel Silver and Kevin Bacon?














// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 25 ******* \\
// **************************** \\
// What's the shortest path between the movie "A Few Good Men" and "The Matrix"?



















// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 26 ******* \\
// **************************** \\
// Now which actor, given the number of shortest paths, should Joel Silver go after, 
// given the choice between Kevin Bacon and Tom Cruise?














// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 27 ******* \\
// **************************** \\
// What are the shortest paths from ron Howard to Ice-T ? Please provide 2 solutions, one using shortestPath() and one not. 
// Also return the number of shortest paths.















// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 28 ******* \\
// **************************** \\
// Find the difference in the number of paths between Tom Cruise and Tom Hanks compared to
//  Tom Cruise and Kevin Bacon that are no more than 5 node hops away. Return just the difference between the the number. 










