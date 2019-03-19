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

limit= {$limit:6}

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
// ******* QUESTION 10 ******* \\
// **************************** \\

// What are the sum, min, max, average, and standard deviation of the price (key:price) of the listings collection?






// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 11 ******* \\
// **************************** \\

// What is the max and avg accomodate capacity for events?





// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 12 ******** \\
// **************************** \\

// Question 12 - $match, $avg, $group, $size, $sum, 
// What is the total number of attendees and the average for events with
// paid users? (key=paid_users)? Collection = listings







// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 13 ******* \\
// **************************** \\
// Question 13
// What is the total revenue earned from all the events? Exclude the _id
// and name total revenue as "revenue". Use paid_users as the number of 
// paid users.







// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 14 ******** \\
// **************************** \\

// Question 14s
// What is the unrealized revenue from attendees who got in for 
// free (key=discountUsers)? And how many attendees in total got in for free?







// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 15 ******** \\
// **************************** \\

// Given events that are not Private (key=isPrivate), find the categories
// (key=categories) that are used the most for events. Sort by 
// this count descending and only return counts which are at least equal to 5.






// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 16 ******** \\
// **************************** \\

// Find the top 5 most abandoned event in a users cart.
// Collection = carts, all events in cart are in a field called "items"
// and each event name has the field "session_name" inside the "items" field.







// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 17 ******** \\
// **************************** \\

// Which user has written the most messages ? Return the top 5 user reference (user_id),
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

// What is the most frequent session theme (key: history -- session_theme, embedded) 
// attendeded grouped by the user offer field. Make sure to remove all user offers where
// the field is not set or empty. 




// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 20 ******** \\
// **************************** \\
// Bucket the Pins collection by number of shares (key:boardCount) and return the average number of shares as well
// as the number of documents in said bucket



// ---------------------------------------------------------------------------------------------------------------------------
// ************************** \\
// ******* QUESTION 21 ******** \\
// **************************** \\
// Group different facets of the listings by Price, Categories (key:listing_type), and total number of attendees 
// in 5 auto-generated buckets.




try {
    while (query.hasNext()){
        printjson( query.next())
    } 
} catch(err){
    printjson(query)
}

