
//**********************// 
//***** Approach ******//
// ******************** //

// ************************** \\
// ******* QUESTION 1 ******* \\
// **************************** \\
// Which stages of the aggregation pipeline encompass the following: db.collection.find({field1: {$gt: 5}}, {field1:1, field2:0} )? Circle one.
// 1. $project and $match
// 2. $match and $group
// 3. ONLY $project
// 4. $group and $project
// 5. ONLY $match


// ANSWER
// 1. $project and $match



// ---------------------------------------------------------------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 2 ******* \\
// **************************** \\ 
// What would the final result look like? Please select one.

//  { $month: "field_name" } converts the date into a month, ranging between 1 and 12
// match = {$match: {
//     "car_make": "tesla"
// }}
// group={$group:{
//     _id:{
//         color:"$color",
//         month:{$month: "date_sold"}
//     },
//     tr:{$sum:{$multiply:["$price", "$numSold"]}},
// }}
// sort = {"tr":-1}

// limit={$limit: 1}

// db.cars.aggregate([match, group, sort, limit])


// 1 - { _id: "color_value", _id: "month_value", tr: "some_number" }
// 2 - { _id: "color_value", _id: "month_value", tr: "some_number" }
// 3 - { _id: "color_value", "month_value", tr: "some_number" }
// 4 - { _id: {"color_value", "month_value"}, tr: "some_number" }
// 5 - { _id: {color: "color_value", month:"month_value"}, tr: "some_number" }


// ANSWER
// 5 - { _id: {color: "color_value", month:"month_value"}, tr: "some_number" }




// ---------------------------------------------------------------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------------------------------------------------------------
//**********************// 
//*** Implementation ****//
// ******************** //
// General References for below:
// SQL to Aggregate Pipeline - https://docs.mongodb.com/manual/reference/sql-aggregation-comparison/

//USE THIS MONGODB -
// mongo "mongodb://cluster0-shard-00-00-jxeqq.mongodb.net:27017,cluster0-shard-00-01-jxeqq.mongodb.net:27017,cluster0-shard-00-02-jxeqq.mongodb.net:27017/aggregations?replicaSet=Cluster0-shard-0" --authenticationDatabase admin --ssl -u m121 -p aggregations --norc





// ************************** \\
// ******* QUESTION 3 ******* \\
// **************************** \\
// Group documents in the movie collection by the number of directors (key: directors array)
// for the movie and sum the number of movies in each grouping. Sort by the number of directors, 
// limit to 3 results. 
// ** NOTE ** remember to guarantee that the directors array exists

match={$match: {
     directors: {$ne: null}
}}

addFields={$addFields: {
    directorCount: {$size: "$directors"}
}}
group={$group: {
    _id:"$directorCount", count: {$sum:1}
}}

// sort={$sort: {"_id": 1}}
sort={$sort: {"dude":1}}


limit={$limit:3}

query = db.movies.aggregate([addFields, group, sort, limit])

// query= db.movies.find({directors: {$size: 1}}).count()

try {
    while (query.hasNext()){
        printjson( query.next())
    } 
} catch(err){
    printjson(query)
}



// ---------------------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 4 ******* \\
// **************************** \\

// Group all documents in the movie collection by their composite tomatoes score ( which is equal to tomatoes.viewer.rating multiplied 
// by tomatoes.viewer.numReviews).
// Sort by the number of documents in each grouping, limit to 3 results.


addFields={$addFields:{
    imdbComp: { $multiply:[ "$tomatoes.viewer.rating", "$tomatoes.viewer.numReviews" ] }
}}
group = {$group:{
    _id:"$imdbComp", total: {$sum:1}
}}

sort={$sort: {total:-1}}

limit={$limit:3}


query = db.movies.aggregate([addFields, group, sort, limit])




// ---------------------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 5 ******* \\
// **************************** \\ 
// Group all documents in the employees collection and sum the count where the employee_compensation.programs.401K_contrib is greater than 0.1, 
// where the count of each grouping is less than 40, sorted descending by employee_compensation.programs.401K_contrib and limit your return
// to 5 results.

// employee_compensation.programs.401K_contrib is the main key.


match={$match:{
    "employee_compensation.programs.401K_contrib": {$gt: 0.1}
}}

group={$group:{
    _id:"$employee_compensation.programs.401K_contrib", count:{$sum:1}
}}

match2={$match: {
    count: {$lt: 40 }
}}

limit={$limit:5}

sort={$sort:{_id:-1}}



project={$project:{
    _id:0, "401k_contr":"$_id", count:1
}}

query=db.employees.aggregate([match, group, match2, sort, limit, project])




