//**********************// 
//***** Approach ******//
// ******************** //
// 5.5 points each

// ************************** \\
// ******* QUESTION 1 ******* \\
// **************************** \\
// How would you write this in Cypher: 
// A teacher who teaches students that live in Los Angeles and attends USC. 

a)  match (teacher)-[:TEACHES]->(s)-[:LIVE_IN]->(:Location{name:"Los Angeles"}),
 (s)-[:ATTENDS]->(u:SCHOOL{name:"USC"})

b) match (teacher)-[:TEACHES]->(s)-[:LIVE_IN]->(:Location{name:"Los Angeles"}),
 (s)-[:ATTENDS]->(u:SCHOOL{name:"USC"})


c) match (teacher)-[:TEACHES]->(s)-[:LIVE_IN]->(:Location{name:"Los Angeles"}),
    (s)-[:ATTENDS]->(u:SCHOOL{name:"USC"})
return s.name

d) match (teacher)-[:TEACHES]-(s)-[:LIVE_IN]->(:Location{name:"Los Angeles"}),
    (s)-[:ATTENDS]->(u:SCHOOL{name:"USC"})
return s.name

// ANSWER: C



// ************************** \\
// ******* QUESTION 2 ******* \\
// **************************** \\
// Place the building blocks of Neo4j in the context of MongoDB. See below:
// Nodes = 
// Labels =
// Relationships =
// Properties = 


// ANSWER: 
// Nodes = Documents
// Labels = Collections
// Relationships = Embedded Object
// Properties = Key/Value pairs
 






//***********************// 
//*** Implementation ***//
// ******************* //
// 11 points each





// ************************** \\
// ******* QUESTION 3 ******* \\
// **************************** \\
// Find all the movies that were released between 2000 and 2010 where the rating
// (:REVIEWED, key:rating) for those movies are either greater than 90 or less than 70. Return the
// movie title (:Movie, key:title), rating, and movie released year (:Movie, key:year). Order by
// rating descending and limit to 3 results.

// For cypher, remember to keep the boolean operators separate. Return the name and born year 
// (key:name, key:born) 
// For example:
// where n.born > 1980 and (OR condition)

// How would you write this in MongoDB without using Aggregation Pipeline, assuming the following:
// Movie Collection
// rating: Number,
// released: Date,
// title


// Part 1 - Neo4j SOLUTION:
match (n:Person)-[r:REVIEWED]->(m:Movie)
where (r.rating >90 or r.rating < 70) and 2000 <= m.released <= 2010
return m.title, r.rating, m.released
order by r.rating desc
limit 3

// Part 2 - MongoDB SOLUTION:
db.movies
.find({ $and:[ {released: {$gte: 2000}}, {released: {$lte: 2010}}, 
{$or: [ {rating:{$gt: 90} }, { rating:{$lt: 70}} ]} ] }, {title:1, rating:1, released:1})
.sort({rating:-1}).limit(3)


// PART 1 and 2 = 5.5 POINTS/EACH






// ---------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 4 ******* \\
// **************************** \\
// Return distinct actors (DISTINCT operator in return clause) of movies that have
// two different reviewers (relationship :REVIEWED). Sort by descending actor
// name (:Person, key:name). Limit to 3 results.

match (r:Person)-[:REVIEWED]->(m)<-[:REVIEWED]-(r2:Person),
(a:Person)-[:ACTED_IN]->(m)
return distinct a.name
order by a.name desc
limit 3


// ANSWER:
// "Tom Hanks"
// "Paul Bettany"
// "Orlando Jones"




// ---------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 5 ******* \\
// **************************** \\
// List 5 friends (via the :HAS_CONTACT relationship) of friends of Tom Hanks who
// he doesn't know immediately (i.e. 2 HAS_CONTACT traversals)  and is born between 1950 and 1960. 
// Return their names and born year (:Person, key:name, key:born) and order by names descending. Limit to 3 results.
// ** NOTE ** Make sure tom is not one of the results. 

match (tom:Person{name:"Tom Hanks"})-[:HAS_CONTACT]->(m), 
(m)-[:HAS_CONTACT]->(c)
where not (tom)-[:HAS_CONTACT]-(c) and not (m)-[:HAS_CONTACT]->(tom) and 1950<c.born<1960
return distinct c.name, c.born
order by c.name desc
limit 3




// ANSWER:
// "Zach Grenier"	1954
// "Vincent Ward"	1956
// "Val Kilmer"	1959




// ---------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 6 ******* \\
// **************************** \\
// List the second-degree actors in Tom’s network with whom he has not acted with but could. In other words,
// we are looking for Tom's co-actors' co-actors (call them coCoActors) where Tom and these coCoActors
// have not acted in any movie together and that none of these coCoActors are Tom. Limit results to 3.

// **** NOTE ****
// To check for this, you can either remove the limit to see if Tom Hanks appears, or
// set the coCoActor name to Tom Hanks and see if any node is returned.

MATCH (tom:Person)-[:ACTED_IN]->()<-[:ACTED_IN]-(coActor:Person),
         (coActor)-[:ACTED_IN]->(l)<-[:ACTED_IN]-(coCoActor:Person)
WHERE tom.name = "Tom Hanks" 
        AND NOT (tom)-[:ACTED_IN]->()<-[:ACTED_IN]-(coCoActor) 
        and not (tom)-[:ACTED_IN]->(l)
RETURN distinct coCoActor.name
order by coCoActor.name desc
limit 3


// ANSWER:
// "Zach Grenier"
// "Val Kilmer"
// "Tom Skerritt"






// ---------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 7 ******* \\
// **************************** \\
// Similar to the last problem, but only show the people that Tom Hanks already knows (:HAS_CONTACT) with because
// then he could easily get a hold of them for his next movie! Limit to 3 results.

MATCH (tom:Person)-[:ACTED_IN]->()<-[:ACTED_IN]-(coActor:Person),
         (coActor)-[:ACTED_IN]->(l)<-[:ACTED_IN]-(coCoActor:Person)
WHERE tom.name = "Tom Hanks" 
        AND NOT (tom)-[:ACTED_IN]->()<-[:ACTED_IN]-(coCoActor) 
        and not (tom)-[:ACTED_IN]->(l)
        AND (tom)-[:HAS_CONTACT]->(coCoActor)
RETURN distinct coCoActor.name
order by coCoActor.name desc
limit 3




// ANSWER:
// "Stephen Rea"
// "Natalie Portman"
// "Keanu Reeves"



