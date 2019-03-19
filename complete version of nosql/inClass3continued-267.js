//**********************// 
//***** Questions ******//
// ******************** //
// Databse to connect to:
// mongo ds145962-a1.mlab.com:45962/joinin -u dso -p uscdso42



// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 1 ******* \\
// **************************** \\

// How many total users are there? 


// db.users.find().count()
// $group stage - {$group: { _id: <matching criteria >}}

query = db.users.aggregate([
    {$group: {
        _id:null, count:{$sum:1}
    }}
])




// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 2s ******* \\
// **************************** \\

// How many total pins (collection = pins) are there? Return the total.


query = db.pins.aggregate([
    {$group: {
        _id:null, count:{$sum:1}
    }}
])



// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 3 ******* \\
// **************************** \\

// 3 - How would you do this with basic querying
// query = db.listings.find().count()


db.listings.aggregate([
    {$group: {
        _id:null, count:{$sum:1}
    }}
])


// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 4 ******* \\
// **************************** \\

// How many total posts are there? Only return the total.



query = db.posts.aggregate([
    {$group: {
        _id:null, count:{$sum:1}
    }},
    // db.coll.find({criteria}, {projection_stage})
    {$project: {
        usc:"$count", _id:0
    }}
])




// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 5 ******* \\
// **************************** \\

// Return the breakdown of the users who have been accepted to the
//  platform (key:isAccepted)
// and those who have not


group = {$group: {
    _id:"$isAccepted", count:{$sum:1}
}}

project={$project:{
    _id:0, isAccepted:"$_id", count:1
}}

query = db.users.aggregate([group, project])



// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 6 ******* \\
// **************************** \\

// What is the breakdown of Post privacy (key: isPrivate) ? 
// Rename isPrivate key to isPriv.

group={$group:{
    _id:"$isPrivate", count: {$sum:1}
}}
//  {count:90, _id: false}
//  {count:90, _id: true}
project={$project: {
    _id:0, isPriv:"$_id", count:1
}}

query = db.posts.aggregate([group, project])





// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 7 ******* \\
// **************************** \\

// What are the top 5 most mentioned post 
// categories (key:post_categories) in the post collection?

group={$group: {
    _id:"$post_categories", count:{$sum:1}
}}

sort={$sort: {count:-1}}

limit={$limit: 5}


query=db.posts.aggregate([group, sort, limit])

// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 8 ******* \\
// **************************** \\

// Group by the size of each listings attendees (key:listing_users) 
// and count the number of events 
// with each attendee count. Sort by the number of events descending and limit to 6.

addFields = {$addFields: {
    totAtt: { $size: "$listing_users"}
}}

group = {$group:{
    _id:"$totAtt", numEvents: {$sum:1}
}}

sort={$sort: { numEvents: -1}}

limit= {$limit:5}

query=db.listings.aggregate([addFields, group, sort, limit])

// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 9  ******* \\
// **************************** \\

// What are the most profitable 
// event (collection=listing, key:price, key:listing_users)?

// {$multiply: [ <expression1>, <expression2> ]}

addFields= {$addFields: {
    profit: {$multiply: [ {$size: "$listing_users"}, "$price" ]}
}}

group ={$group: {
    _id:"$profit", numEvents: {$sum:1}
}}

sort={$sort: {numEvents: -1}}

limit={$limit:5}

query=db.listings.aggregate([addFields, group, sort, limit])





// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* REVIEW QUESTIONS  ******* \\
// **************************** \\


// 1 - Return the count of the number of users that 
// have an offer (k:offer) value of "Business Dev"


db.users.find({offer:"Business Dev"}).count()





// 2 - Group the pins by boardCount. Sort on count 
// per grouping descending, and limit to 3.


group={$group:{
    _id:"$boardCount", count:{$sum:1}
}}
limit={$limit:3}
sort={$sort:{
    count:-1
}}

query= db.pins.aggregate([group, sort, limit])

// 3 - Group the users by the offer field and return the count 
// per grouping. Sort by this count descending and limit to 3. 
// Note, make sure that the field exists and is not an empty string.

match={$match:{
   $and: [ {offer:{$ne:null}}, {offer:{$ne:""}} ]
}}
group={$group: {
    _id:"$offer", count:{$sum:1}
}}
limit={$limit:3}
sort={$sort:{
    count:-1
}}

query = db.users.aggregate([match, group, sort, limit])




// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 10 ******* \\
// **************************** \\
// What are the sum, min, max, average, and standard deviation 
// of the price (key:price) of the listings collection?
// $sum, $min, $max, average, and standard deviation of sample
//  of the price


group={$group:{
    _id:null,
    count:{$sum:1},
    avg:{$avg:"$price"},
    max:{$max:"$price"},
    min:{$min:"$price"},
    stDev:{$stdDevSamp:"$price"}
}}

project = {$project: {
    _id:0, count:1, avg:1, min:1, max:1, stDev:1
}}


query = db.listings.aggregate([group, project])

// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 11 ******* \\
// **************************** \\
// What is the max and avg accomodate capacity for events?

group={$group:{
    _id:null,
    avg:{$avg:"$accomodate"},
    max:{$max:"$accomodate"}
}}

query = db.listings.aggregate([group])

// 1 - "$field"
// 2 - $stage e.g. $match, $group
// 3 - $operator e.g. $ne, $gt
// 4 - {} vs []
// 5 - checking file for previous errors

// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 12 ******** \\
// **************************** \\
// Question 12 - $match, $avg, $group, $size, $sum, 
// What is the total, average, max and min number of 
// attendees, as well as the number
// of events?? (key=paid_users)? Collection = listings

match={$match: {
    "paid_users": {$ne: []}
}}

addFields={$addFields:{
    numOfAtt: {$size: "$paid_users"}
}}

group={$group: {
    _id:null,
    total:{$sum: "$numOfAtt"},
    avg: {$avg: "$numOfAtt"},
    min: {$min: "$numOfAtt"},
    max: {$max: "$numOfAtt"},
    count: {$sum:1}
}}

query = db.listings.aggregate([match, addFields, group])


// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 13 ******* \\
// **************************** \\
// What is the total revenue earned from all the events? 
// Exclude the _id
// and name total revenue as "revenue". Use paid_users as the 
// number of 
// paid users.

match= {$match: {"paid_users": {$ne: []}}}

group = {$group: {
    _id:null,
    total: {$sum: {$multiply:[{  $size:"$paid_users"}, "$price" ]}}
}}

project = {$project:{
    _id:0, revenue: "$total"
}}

query = db.listings.aggregate([match,group, project])

// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 14 ******** \\ 
// **************************** \\
// What is the unrealized revenue from attendees who got in for 
// free (key=discountUsers)? And how many attendees in total got in for free?
















// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 15 ******** \\
// **************************** \\
// Given events that are not Private (key=isPrivate), find the 
// categories
// (key=categories) that are used the most for events. Sort by 
// this count descending and only return counts which are at 
// least equal to 5.

// $unwind - unwind an array field to analyze each document separately 
// create a new document per input value of the array field

// if grouping by a field with an array, it's matched on pure
// equality not equivalence
//  ["Action", "Adventure"] != ["Adventure", "Action"]



match1 = {$match: {
    "isPrivate": {$ne : true}
}}
unwind = {$unwind: "$categories"}

group = {$group:{
    _id:"$categories", count:{$sum:1}
}}
match2 = {$match: {
    count:{$gte:5}
}}
sort= {$sort: {count:-1}}
limit = {$limit: 3}

query = db.listings.aggregate([match1, unwind, group, match2, sort, limit])








// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 16 ******** \\
// **************************** \\
// Find the top 5 most abandoned events in a users cart.
// Collection = carts, all events in cart are in a field 
// called "items"
// and each event name has the field "session_name" inside the 
// "items" field.


match = {$match: {
    "items.session_name": {$ne: null} 
}}
unwind = {$unwind: "$items"}
group= {$group: {
    _id:"$items.session_name", count: {$sum:1}
}}
sort={$sort: {count:-1}}
limit={$limit:5}

query = db.carts.aggregate([match, unwind, group, sort, limit])






// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 17 ******** \\
// **************************** \\
// Which user has written the most messages by group size (key:userData) ? Return the top 5 user (user_id),
// group size (key:userData), and count. Sort by count descending.
// Collection = inboxes
// messages are in a field  = "messages" which is an array of embedded documents












// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 18 ******** \\
// **************************** \\
// Group the following by month they joined the platform(key:created_at) and
// what the user offers (key:offer) the community. Return the list sorted 
// descending on the number of people per group and limit to 5









// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 19 ******** \\
// **************************** \\
// Return the list of session theme (key: history -- session_theme, embedded) 
// attendeded grouped by the user offer field. In other words, session_theme per offer,
// and then grouped all into larger groupings of offers. Make sure to remove all user offers where
// the field is not set or empty. 





try {
    while (query.hasNext()){
        printjson( query.next())
    } 
} catch(err){
    printjson(query)
}

