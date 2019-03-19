
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


match (n:Person{name:"Keanu Reeves"})-[:HAS_CONTACT]-(f:Person)
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
match (p:Person)-[:ACTED_IN]->(m:Movie)<-[:ACTED_IN]-(p2:Person {name:"Jack Nicholson"})
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
// ---------------------------------------------------------------------------------------------------------------------------
// *************************************** \\
// ******* REVIEW QUESTIONS Part 2  ******* \\
// ***************************************** \\

// 1 - In Person, find a node1 who has contact with a node2 (:HAS_CONTACT), 
// where this node2 has contact with a node3 (:HAS_CONTACT), 
// and that node3 has some kind of relationship
// to a movie but node2 has no contact going to/directed to 
// node1. Return the node1 name (key:name), 
// the relationship type, title of the movie (key:title), 
// and node3 name. Order by 
// node3 name (key:name) descending, and limit to 1 record.



match (p:Person)-[:HAS_CONTACT]-(p2:Person)-[:HAS_CONTACT]-(p3:Person)-[r]->(m:Movie)
where not (p2)-[:HAS_CONTACT]->(p)
return p.name, type(r), m.title, p3.name
order by p3.name desc
limit 1









// 2 - Find a node1 that has contact (:HAS_CONTACT) with a node2, 
// where this node2
// has reviewed (:REVIEWED) a node3 that has a relationship 
// going to/directed toward it from a 
// node4 that has acted in a node5 that has also 
// been reviewed by a node6.
// Return the title of node3, the name of node4, 
// order by node5 title descending 
// and limit to 1 result


match (p1:Person)-[:HAS_CONTACT]-(p2:Person)-[:REVIEWED]->(n3:Movie)<-[r]-(p4:Person)-[:ACTED_IN]->(n5:Movie)<-[:REVIEWED]-(p6:Person)
return n5.title, p4.name 
order by n5.title desc 
limit 1








// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 15 ******* \\
// **************************** \\
// Find all actors and return their name, number of movies 
// they have acted in as MovieCount, 
// sum of their earnings as Total, minimum earnings as Min, maximum 
// earnings as Max, and average earnings as Avg. 
// Collect all the movies by title (only) they acted in, 
// actor earnings and sort by MovieCount from greatest to smallest.



// Aggregations in Cypher - you dont specify grouping key. No group
// by clause. AS soon as aggregation is used, all non-aggregated
// columns act as the grouping key. Grouping is done implicitly.


// Step 1:
// Movie Count = all the movies an actor has acted in
// COUNT() - count(*), count(condition/column)

match (k:Person {name:"Keanu Reeves"})-[r:ACTED_IN]->()
return k.name, sum(r.earnings)

match (k:Person {name:"Keanu Reeves"})-[r:ACTED_IN]->(m)
return k.name, count(m.title)// k.name = unaggregated column/property
// where all other columns are aggregated against

// SQL
select name, count(*)
from person as p
join ...
group by...

// MongoDB
db.person.aggregate({
    $group: {
        _id: "$name",
        earnings: {$sum: "$earnings"}
    }
})


// Step 2:
// sum/min/max
// returns output with respect to aggregate applied



// Step 3:
// Collect()
// use this to aggregate data by combining multiple values into a single list
// (key:born)

// Find all the Person nodes where the person was born after
// 1970. REturn their names and count.

match (p:Person)
where p.born > 1970
return count(p), collect("name: "+p.name+" born:"+p.born)


// Step 4:
// WITH
// filter output before it is passed down to other parts of the query
// similar to aggregation results in the "return" clause

match (p:Person)-[r:ACTED_IN]->(m:Movie)
with p.name as Name, r.earnings as e, m.title as m
return name, e, m

// aggregation in WITH
match (p:Person)-[r:ACTED_IN]->(m:Movie)
with p.name as Name,  collect(m.title) as m
return Name, m
limit 1

// Count the number of movies an actor has acted in where 
// the actor has acted in more than 1 movie but less than 4. Return
// the actor name, count of movies as MovieCount and movie titles.
// Order by MovieCount descending.

match (p:Person)-[r:ACTED_IN]->(m:Movie)
with count(m) as MovieCount, p, collect(m.title) as title
where MovieCount>1 and MovieCount<4
return p.name, MovieCount, title 
order by MovieCount desc


// When using WITH, make sure to specify ALL the variables you need
// in the stages of the query afterwards






// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 16 ******* \\
// **************************** \\
// Count the number of paths found for each pair of nodes
// where node1 has an acted in (:ACTED_IN) relationship and a node2
// has directed (:DIRECTED) relationship to movies. Order by the count
// of thess pairings descending and rename the count as Collaborations



match (p:Person)-[:ACTED_IN]-(m:Movie)-[:DIRECTED]-(p2:Person)
return p.name, p2.name, count(m.title) as Collaborations, collect(m.title)
order by Collaborations desc 










// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 17 ******* \\
// **************************** \\
// Group all nodes by the type of relationship
// a node has to a movie, and return the count per
// relationship type. Rename the count as relCount and 
// order by descending.

match (p)-[r]->(m:Movie)
return type(r), count(p) as relCount // count(r)
order by relCount desc






// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 18 ******* \\
// **************************** \\
// By node (label:Movie) year released (key:released), 
// find the total cost of the (:ACTED_IN, key:earnings)
// nodes that acted in (:ACTED_IN) those nodes for that year. 
// Order by year. Return the year, total cost as Cost, 
// and the node titles (key:title)
// for that year.


match (p:Person)-[r:ACTED_IN]->(m)
return m.released, sum(r.earnings) as Cost, collect(m.title)
order by m.released





// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 19 ******* \\
// **************************** \\
// Find all actors where there total earnings is greater 
// than $60M and only 
// return their name and total earnings (:ACTED_IN, key:earnings). 
// Sort by total earnings. Use the WITH clause

match (p:Person)-[r:ACTED_IN]->(m)
with p.name as name, sum(r.earnings) as total
where total > 60000000
return name, total
order by total desc







// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 20 ******* \\
// **************************** \\
// By number of movies acted in, group actors 
// who acted in more than 4 
// movies and return the total earnings as well as 
// average earnings for that grouping. Return by movie count,
// a list of actors, average earnings and total movies.

// avg(),sum(),max(), etc

match (p:Person)-[r:ACTED_IN]->(m)
with p.name as name, sum(r.earnings) as Total, count(m) as Count 
where Count > 4
return collect(name), sum(Total), Count, avg(Total) 
order by Count desc





// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 21 ******* \\
// **************************** \\
// By number of total roles, group actors 
// who have played more than 3 roles.
// Return the total number of roles and
// total earnings. Order by total roles
// descending.

// (:ACTED_IN, key:roles, array)
match (p:Person)-[r:ACTED_IN]->(m)
with p.name as name, sum(size(r.roles)) as count, sum (r.earnings) as total
where count > 3
return collect(name),count, sum(total) 
order by count desc












// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 22 ******* \\
// **************************** \\
// Suggest new writers to directors (lets call them, D1 directors) 
// via other people that 
// these directors (D1) have contact (D1->) with
// that have also directed movies (D2). Make sure these 
// set of writers have never worked with 
// those directors (D1). Return the grouping
// by the first group of directors (D1), the writers 
// that directors (D1) has worked with 
// as "worked with writers", and the new suggested
// writers as "suggested writers" and limit to 3.


match (p1:Person)-[:DIRECTED]->(m:Movie),
(p4)-[:WROTE]->(m),
(p1)-[:HAS_CONTACT]->(p2:Person),
(p2)-[:DIRECTED]->(m2:Movie)<-[:WROTE]-(p3)
where not (p1)-[:DIRECTED]->()<-[:WROTE]-(p3)
return p1.name, collect(distinct p3.name) as `suggest writer`,
collect(distinct p4.name) as `worked with writers`
order by p1.name desc
limit 3

// (p3)-[:WROTE]->(m3)<-[:DIRECTED]-(p1)











// ---------------------------------------------------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------------------------------------------------
//****** VARIABLE LENGTH PATH ******\\


// ************************** \\
// ******* QUESTION 23 ******* \\
// **************************** \\
// Find all the nodes 2 :HAS_CONTACT traversals/node hops away from Tom Hanks
// who have acted  
// in a movie, where that person is not Tom Hanks. 
// Find the size of that group of people who 
// have acted in those movies and return that size.










// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 24 ******* \\
// **************************** \\
// Find all the nodes that Tom Hanks is 2 :HAS_CONTACT 
// node hops/traversals away from which he does not
// have any direct contact with and 
// where these nodes have acted in a movie that Tom Hanks 
// has not acted in that same movie.










// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 24 ******* \\
// **************************** \\
// Find a path from Nora Ephron via :DIRECTED or :PRODUCED 
// relationship that is no more than 3
// node hops away. 








// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 25 ******* \\
// **************************** \\
// What's the shortest path between Joel Silver and Kevin Bacon?









// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 26 ******* \\
// **************************** \\
// What's the shortest path between the movie "A Few Good Men" and "The Matrix"?








// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 26 ******* \\
// **************************** \\
// Now which actor, based on the total number of shortest paths, 
// should Joel Silver go after, 
// given the choice between Kevin Bacon and Tom Cruise?








// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 27 ******* \\
// **************************** \\
// What are all the shortest paths from ron Howard to Ice-T ? 
// Please provide 2 solutions, one using shortestPath() and one not. 
// Also return the number of shortest paths.







// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 28 ******* \\
// **************************** \\
// Find the difference in the number of paths between Tom Cruise and Tom Hanks compared to
//  Tom Cruise and Kevin Bacon that are no more than 5 node hops away. Return just the difference between the the number. 






// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 29 ******* \\
// **************************** \\
// The Facebook query:
// Find Friend(s) that Tom Hanks and Tom Cruise have in common (via :HAS_CONTACT)
// but dont yet know each other.

