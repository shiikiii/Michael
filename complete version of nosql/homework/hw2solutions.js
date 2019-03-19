//**********************// 
//***** Approach ******//
// ******************** //

// Section 1 - Approach
// 1. What are the fundamental characteristics of MongoDB (document database)? Please circle all that apply.
// -Schemaless 
// -Flexible
// -Consistent
// -Highly Available

// ANSWER:
// -Schemaless 
// -Flexible
// -Consistent




// 2. In MongoDB, how do you query for a value inside an embedded document? Circle one. Assume `field` refers to the field identifying the embedded document.
// -field[“value”]
// -field.”value”
// -field.value
// -”field.value”

// ANSWER:
// -”field.value”





// 3. Assuming the same collection and database, will these two statements necessarily always return the same result → age: {$not: {$lt: 20}} vs age: {$gte:20} ? Circle all that may apply.
// -Yes, they mean the same thing
// -No, $gte is not the same as not less than something
// -No, comparison operators (e.g. $lt) check against a value, logical operators (e.g. $not) operates on other operators
// -No, comparison operators (e.g. $lt) operators on other operators, logical operators (e.g. $not) check against a value

// ANSWER:
// -No, comparison operators (e.g. $lt) check against a value, logical operators (e.g. $not) operates on other operators






// 4. In what order do the chaining functions of sort(), skip(), and limit() get executed? Circle one.
// -sort() → skip() → limit()
// -skip() → sort() → limit()
// -limit() → sort() → skip()
// -limit() → skip() → skip()

// ANSWER:
// -sort() → skip() → limit()





//**********************// 
//*********************// 
//** IMPLEMENTATION **//
//** ****************//
//******************//

// Connect to the following MongoDB (we used during class)
// mongo ds139705.mlab.com:39705/usc_nosql -u usc -p usc553



//*********************************// 
//****** Athlete Collection ******//
//*******************************//

// ---------------------------------------------------------------------------------------------------------------------------------------
// 1. What’s the total number of people who are either from Italy (key=NOC, value="ITA") and won the Gold or
// from Jamaica (key=NOC, value="JAM") and did not win a Gold ? Please include the code and the final result.


db.athlete.find({$or: [{"NOC":"ITA", "Medal":"Gold"}, {"NOC":"JAM","Medal":{$ne:"Gold"}} ]}).count()
db.athlete.count({$or: [{"NOC":"ITA", "Medal":"Gold"}, {"NOC":"JAM","Medal":{$ne:"Gold"}} ]})
// ANSWER: 1385

// ---------------------------------------------------------------------------------------------------------------------------------------
// 2. Write the below SQL as a MongoDB query. Please include the answer and the code.
`
SELECT COUNT(*)
FROM athlete
WHERE Age BETWEEN 29 AND 31 AND Sex = "F" AND Medal = "Gold" AND Year > 2012
`

// CODE:
db.athlete.find({Age:{$gte: 29, $lte:31}, Sex:"F", Medal:"Gold", Year:{$gt: 2012}}).count()
// ANSWER: 65 



//*********************************// 
//******* Nobel Collection *******//
// ***************************** //
// **use nobel collection



// -------------------------------------------------------------------------------
// 3. How many nobel laureates won prizes in the category (key: prizes - category) of 
// chemistry or physics (value: chemistry, value:physics) and won prizes with affiliations country 
// (key: prizes - affiliations - country) as the Netherlands or United Kingdom (value: the Netherlands, value: United Kingdom)?
// Please include the code and the final result.




db.nobel.find({$and: [{"prizes.category": {$in :["physics", "chemistry"] }}, {"prizes.affiliations.country": {$in: ["United Kingdom","the Netherlands"]}}] }).count()
// ANSWER: 61


// --------------------------------------------------------------------------------------
// 4. Return the count of all the documents in the nobel collection where no value in the
// new score array (key: new_score_array) is greater than 85 and the new array (key:new_array)
// has the the following elements: pink, green (value: "pink", value:"green"). Please include the code and the final result.




db.nobel.find({ new_score_array: {$not: {$gt: 80}}, new_array: { $all: ["pink", "green"]} } ).count()
// ANSWER:
// 4


// -------------------------------------------------------------------------------
// 5. Write the following SQL query in MongoDB. Please include the code and the final result.
// Must use the $nin operator here. It is exactly the same as the $in operator in syntax.

`SELECT firstname 
FROM nobel 
WHERE new_array IN ("ruby","green") AND new_score_array NOT IN (51,77) AND gender="male" 
ORDER BY firstname desc
LIMIT 1`


db.nobel.find({gender:"male", new_array:{$in:["ruby","green"]}, new_score_array:{$nin:[51, 77, 90]}},{firstname:1,_id:0}).sort({firstname:-1}).limit(1)

// ANSWER:
// { "firstname" : "Sir Frank Macfarlane" }



//**********************************// 
//***** Restaurant Collection *****//
// ****************************** //

// -------------------------------------------------------------------------------------------------------------------------
// 6. What’s the name of the restaurant whose grade (key: grades -- grade) is not “Not Yet Graded” (value: "Not Yet Graded")
// sorted by grades date (key:grades -date) descending ? Please include the code and the final one result.

db.restaurant.find({"grades.grade":{$ne:"Not Yet Graded"}},{name:1}).sort({"grades.date":-1}).limit(1)

