
//**********************// 
//***** Questions ******//
// ******************** //
// Databse to connect to:
// mongo "mongodb://cluster0-shard-00-00-jxeqq.mongodb.net:27017,cluster0-shard-00-01-jxeqq.mongodb.net:27017,cluster0-shard-00-02-jxeqq.mongodb.net:27017/aggregations?replicaSet=Cluster0-shard-0" --authenticationDatabase admin --ssl -u m121 -p aggregations --norc
// Collection = movies

// In your command line, load the file you downloaded using load("filePath.js") and it should return your query.



// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 1 ******* \\
// **************************** \\

// How many movies have a tomatoes viewer rating (key:tomatoes - viewer - rating) of 
// greater than
// 4 but less than 5 and include USA and France as their countries of release 
// (key:countries)?

db.movies.find({$and: [ {countries:"USA"}, {countries:"France"}, {"tomatoes.viewer.rating": {$gt: 4}}, {"tomatoes.viewer.rating": {$lt: 5}} ] }).count()

db.movies.find({$and: [{countries: {$all: ["USA", "France"]}}, {"tomatoes.viewer.rating": {$gt: 4}}, {"tomatoes.viewer.rating": {$lt: 5}} ]}).count()



// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 2 ******* \\
// **************************** \\

// How many items in movies collection are neither a type of
//  movie or series (key: type, value: "movie", "series")
// and the first value in the genres array is Comedy (key:genres)?


db.movies.find({ type:{$nin:["movie","series"]}, "genres.0":"Comedy"  }).count()



// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 3 ******* \\
// **************************** \\

// Return an ONLY the title of the item from movies collection where the genres 
// array has Comedy and Action,
// an imdb rating (key: imdb - rating) and tomatoes viewer rating 
// (key: tomatoes-viewer-rating)
// of greater than 0, and sort by imdb rating and tomatoes 
// viewer rating descending, in that order.


db.movies.find({ genres: {$all: ["Comedy","Action"]}, "imdb.rating": {$gt:0}, "tomatoes.viewer.rating":{$gt:0}}, {title:1, _id:0} ).sort({"imdb.rating":-1, "tomatoes.viewer.rating":-1 } ).limit(1)




// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 4 ******* \\
// **************************** \\

// How many movies are either in the genres (key:genres) array with a value 
// of "Documentary" or "Drama" or have
// an imdb rating (key:imdb - rating) of greater than equal to 6, 
// and have a type of movie (key:type, value:"movie"),
// a country of USA (key:countries, value:"USA"), released after 
// 2012 (key: year), and more
// than 600 imdb votes (key:imdb - votes)

db.movies.count({$and: [ 
    {$or: [ {genres: {$in: ["Documentary","Drama"]}}, {"imdb.rating": {$gte: 6}} ] }, 
    {type:"movie", year: {$gt:2012}, countries:"USA", "imdb.votes":{$gt:600}}
] })




// THIS here will return the result from running your query after running the load("filePath.js") command
try {
    while (query.hasNext()){
        printjson( query.next())
    } 
} catch(err){
    printjson(query)
}








