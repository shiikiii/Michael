//***********************// 
//***** Questions ******//
// ******************* //
// Database to connect to
// mongo ds139705.mlab.com:39705/usc_nosql -u usc -p usc553


// COMMANDS in prompt
// show dbs -- show dbs
// db -- show active db
//  use db --- select db
// show collections 

// -------------------------------------------------------------------------------------------------------------------------------------

// I. Intro MongoDB Queries(limit, skip, find/findOne, sort, count)
// QUESTION 1 - Convert the SQL to MongoDB

// Part A: 
// Find the total count of documents in the person collection

`
SELECT COUNT(*)
FROM person
`
db.person.find({}).count()
// empty braces {} is similar to the * in SQL. Not required.


//  Part B: 
// Return only the name, isActive and gender attribute of one document

`
SELECT name, isActive, gender
FROM person
LIMIT 1
`
db.person.find({},{name:1, isActive:1, gender:1, _id:0}).limit(1)
db.person.findOne({},{name:1, isActive:1, gender:1, _id:0})
// ***Note: _id is always returned so you must explicitly unset it in the projection***
'Sort (before)--> Skip --> Limit regardless of order you enter query, server determines order'

// -------------------------------------------------------------------------------------------------------------------------------------
// QUESTION 2 (Student) - 
// Return ONLY (no ObjectId) the index(key) and favoriteFruit(key). Limit to 1 result
// Show 2 ways of arriving at this result and limit to 1 result.

db.person.find({},{index:1, favoriteFruit:1, _id:0}).limit(1)
db.person.findOne({},{index:1, favoriteFruit:1, _id:0})




// -------------------------------------------------------------------------------------------------------------------------------------


// QUESTION 3 (Student) - Write the below SQL as a MongoDB query. Also return the company title (key=company.title).
// Remember to use "dot" notation.
// dict = {'person': {'age': 5, 'name': 'Tony'}, 'day': 'Tuesday'}
// dict['person']
// {'age': 5, 'name': 'Tony'}
// dict['person']['age']
`
SELECT name, tags 
FROM person
ORDER BY index desc
LIMIT 1
`
db.person.find({},{name:1, "company.title":1,tags:1, _id:0, index:1}).sort({index:-1}).limit(1)

// sort --> 1 = ascending, -1 = descending
// always pass in an object, with the field you wish to sort on as well as the sorting pattern (Asc,desc).

// NOTE *****
'Sort (before)--> Skip --> Limit regardless of order you enter query, server determines order'

// -------------------------------------------------------------------------------------------------------------------------------------

// QUESTION 4 (Student) - Convert the SQL below into MongoDB. Using sort method.
// Return a document projecting only name, age, gender, and eyeColor.
//  Sort by age ascending and limit to 1 result. 
`
SELECT name, 
age, 
gender,
eyeColor
FROM person
ORDER BY age ASC
`
db.person.find({},{ _id:0, name:1, age:1, gender:1, eyeColor:1}).sort({age:1}).limit(1)


// QUESTION 5 (Student) - How might you sort by the following two fields, age ASC and 
// eyeColor DESC ?
db.person.find({},{ _id:0, name:1, age:1, gender:1, eyeColor:1}).sort({age:1, eyeColor:-1}).limit(2)




// -------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------------------------

// II. Comparison Operators (https://docs.mongodb.com/manual/reference/operator/query-comparison/)
// QUESTION 6 -
// Return name and age of a document where the age is 21, ordered by name descending and limit to 1
`
SELECT name, age
FROM person
WHERE age = 21
ORDER BY name DESC
LIMIT 1
`
db.person.find({age:21}, {_id:0, name:1, age:1}).sort({name:-1}).limit(1)
// query criteria, projection, sort and limit
// sorting has a 32mb limit. So remember to use sort with a limit or make sure there's an
// index of some sort.
// To check Indexes, use the following command: db.person.getIndexes()
// Can do compound sorting -- {a:1, b:1} as well 
db.person.find({age:21}, {_id:0, name:1, age:1}).sort({age:1, eyeColor:-1}).limit(1)
// VS
db.person.find({age:21}, {_id:0, name:1, age:1}).sort({age:1, eyeColor:1}).limit(1)


// -------------------------------------------------------------------------------------------------------------------------------------


// QUESTION 7 - 
// Return a document where the eyeColor(key) is brown(value), gender(key) is female(value), favoriteFruit(key) 
// is NOT banana(value), and only return these values. Sort by age(key) descending, and limit to 1 result.  
// $ne
`
SELECT eyeColor, gender, favoriteFruit
FROM person
WHERE eyeColor="brown" AND gender="female" AND favoriteFruit!="banana"
ORDER BY age DESC
LIMIT 1
`
db.person.find({eyeColor:"brown", gender:"female", favoriteFruit:{$ne:"banana"}}, {_id:0, favoriteFruit:1, gender:1, eyeColor:1}).sort({age:-1}).limit(1)


// -------------------------------------------------------------------------------------------------------------------------------------
// QUESTION 8 (Student) - 
// Return a document where age is greater than or equal to 20, sort age in DESC order, limit to 1 result and
// only return name and age.
// ($gte)
`
SELECT name, age
FROM person
WHERE age >= 20
ORDER BY age DESC
LIMIT 1
`

db.person.find({age:{$gte:20}},{name:1, age:1,_id:0} )
.sort({age:-1}).limit(1)

// all comparison operators have a similar syntax:
// $lt, $lte, $gt, $ne, $eq


// -------------------------------------------------------------------------------------------------------------------------------------
// QUESTION 9 (Student) - Write the below SQL as a MongoDB query ($lte)
// Return a document with only the name and age field where the age is less than or equal 20. 
// Order by name descending and limit to 1 result.
`
SELECT name, age
FROM person
WHERE age <= 20
ORDER BY name DESC
LIMIT 1
`

db.person.find({age:{$lte:20}},{name:1, age:1,_id:0})
.sort({name:-1}).limit(1)


// -------------------------------------------------------------------------------------------------------------------------------------
// QUESTION 10 - 
// Return a document where the age is in 20 or 23 and sorted by name descending. Return only one document.


// {field: {$in: [x,y, etc]}} or $nin
// ($in, $nin)

`
SELECT name, age
FROM person
WHERE age in (15, 20) 
ORDER BY name DESC
LIMIT 1
`
db.person.find({age: {$in: [23,20]}}).sort({name:-1}).limit(1)

// SUB (Student) -  How many documents fit this condition?
db.person.find({age: {$in: [23,20]}}).count()
// how can you verify this?
db.person.find({age: 20}).count()
+
db.person.find({age: 23}).count()




// -------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------------------------
// III. Logical Operators (https://docs.mongodb.com/manual/reference/operator/query-logical/)

// QUESTION 11 - 
// Return the count of documents in person collection where the age is not equal to 21 or
// the favoriteFruit(key) is "strawberry"(value)



// { $or: [ { <expression1> }, { <expression2> }, ... , { <expressionN> } ] }
// this is the same for $and
`
SELECT COUNT(*)
FROM person
WHERE eyeColor=blue OR eyeColor=brown
`
db.person.find({$or: [{eyeColor:"blue"}, {eyeColor: "brown"} ] }).count()

// ALSO similar to $in operator
db.person.find({eyeColor:{$in:["blue", "brown"]}}).count()
// -------------------------------------------------------------------------------------------------------------------------------------

// QUESTION 12 (Student) -  
// Return the count of documents in person collection where the age is 21 and
// the favoriteFruit(key) is "strawberry"(value)



// Note - $and is structurally identical to $or.
`
SELECT COUNT(*)
FROM person
WHERE eyeColor="green" AND age=21
`

db.person.find({$and: [{age:21}, {eyeColor: "green"}] }).count()
// SUB (Students) - What's another way of writing this?
db.person.find({age:21, eyeColor: "green"}).count()




// -------------------------------------------------------------------------------------------------------------------------------------
// QUESTION 13 -  
// Return the count from the person collection where age is not greater than 20.



// Syntax: { field: { $not: { <operator-expression> } } }
// ****NOTE - includes documents for which the specificed field in the expression does not exist
// within the document


db.person.find({age: {$not: {$gt:20}}}).count()

// ****NOTE***
// $not -- matches operator experession and where field doesnt exist
// $lt -- field must exist
"{$not: {$gt:20}} vs {$lt:20}"



// -------------------------------------------------------------------------------------------------------------------------------------
// QUESTION 14 -  
// Return the count of all the documents in the person collection where the gender(key) is 
// $not $ne to "female"(value)


`
SELECT COUNT(*)
FROM person
WHERE NOT gender!="gmae" 
`
db.person.find({gender: {$not: {$ne:"female"}}}).count()
// **Note - $not logical operator checks against an expression, whereas
// comparison operator checks against a value

// What is another way of writing this?
db.person.find({gender: "female"}).count()

// -------------------------------------------------------------------------------------------------------------------------------------

// QUESTION 15 -  Return the total count of the number of documents that
// have either an eyeColor of green or brown and an age of less than 20 or age of 27
`
SELECT COUNT(*)
FROM person
WHERE eyeColor="green OR eyeColor="brown" AND age <20 or age=27
`
db.person.find({$and:[ { $or : [ { eyeColor : "green" }, { eyeColor : "brown" } ] },{ $or : [ { age : {$lt:20} }, { age :  27} ] }]}).count()

// NOTE ----- rator is necessary when the same field or operator has to be specified in multiple expressions.

// or break it apart:
let cond1 = { $or : [ { eyeColor : "green" }, { eyeColor : "brown" } ] }
let cond2 = { $or : [ { age : {$lt:20} }, { age :  27} ] }
db.person.find({$and:[cond1, cond2]}).count()




// -------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------------------------
// IV. Array and Embedded Document Operators 
// i.e. list vs list of dictionaries in python



// QUESTION 16 -
// Return count of all documents that has the following tags array: ["enim","id", "velit", "ad","consequat"]

db.person.find({tags: ["enim","id", "velit", "ad","consequat"]}).count()       // sequence matters









// -------------------------------------------------------------------------------------------------------------------------------------
// QUESTION 17 -  Return the count of all the documents that have the "ad" element in the tag
// array and the "id" element in the second position of the tag array.(index)


db.person.find({"tags.1": "id", tags:"ad"}).count()









// -------------------------------------------------------------------------------------------------------------------------------------
// QUESTION 18-  Return the count of all the documents where the tags array 
// includes the following values: "velit", "enim".($all)

db.person.find( { tags: { $all: [ "velit", "enim" ] } } ).count()
db.person.find( {$and: [{ tags:"velit"}, {tags:"enim"}]}).count()








// -------------------------------------------------------------------------------------------------------------------------------------
// QUESTION 19
// Find the count of all documents in the person collection where the age greater than 20 
// but less than 26, the gender is male, and the company's location country is USA

db.person.find({age:{$gt:19, $lt:25}, gender:"female", "company.location.country":"USA"}).count()













// -------------------------------------------------------------------------------------------------------------------------------------
// QUESTION 20
// How many documents have either a company location country of Italy or France or have a tags
// value of "ad" at the 4th position?

db.person.find({$or:[{"tags.3":"ad"},{"company.location.country":"Italy"}, {"company.location.country":"France"}]}).count()










// -------------------------------------------------------------------------------------------------------------------------------------
// QUESTION 21
// How many nobel laureates were born either in the US or France and won prizes in either physics or chemistry ?
// ** Tips: review $and, $or, $in, and embedded documents
// ** Example鈫� db.collectionName.find({$and: [{key: expression },{$or: [{ expression },{ expression }] }]} ).count()

db.nobel.find({$and: [{bornCountryCode: {$in :["US", "FR"] }}, {$or: [{"prizes.category":"physics"},{"prizes.category":"chemistry"}]}] }).count()

db.nobel.find({$and: [{bornCountryCode: {$in :["US", "FR"] }}, {"prizes.category": {$in: ["physics", "chemistry"]}}]}).count()









// -------------------------------------------------------------------------------------------------------------------------------------
// QUESTION 22
// ONLY return the first name (k:firstname) of the person who is female (k:gender, v:female) won a prize in physics 
// (k:prizes, category, v:chemistry), has a prize affiliation city of Paris (k:prizes, affiliation, city, v:"Paris")
// and has a new array value of ruby or green (k:new_array, v:"ruby","green"). Sort by first name descending and limit to one result. 

db.nobel.find(
    {"prizes.affiliations.city":"Paris", gender:"female", "prizes.category":"chemistry", new_array:{$in:["ruby","green"]}},
    {firstname:1,_id:0}).sort({firstname:-1}
        ).limit(1)












// -------------------------------------------------------------------------------------------------------------------------------------
// QUESTION 23 - Translate the below:
`SELECT firstname 
FROM nobel 
WHERE new_array IN ("ruby","green") AND new_score_array NOT IN (51,77) AND gender="male" 
ORDER BY firstname desc
LIMIT 1`


db.nobel.find({gender:"male", new_array:{$in:["ruby","green"]}, new_score_array:{$nin:[51, 77, 90]}},{firstname:1,_id:0}).sort({firstname:-1}).limit(1)