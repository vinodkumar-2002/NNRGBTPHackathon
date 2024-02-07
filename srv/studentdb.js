const cds = require("@sap/cds");

function calcAge(dob) {
  var today = new Date();
  var birthDate = new Date(Date.parse(dob));
  var age = today.getFullYear() - birthDate.getFullYear();
  var m = today.getMonth() - birthDate.getMonth();
  if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
    age--;
  }
  return age;
}

function hasDuplicates(array) {
  const valueSet = new Set();

  for (const obj of array) {
      const values = Object.values(obj);
      for (const value of values) {
          if (valueSet.has(value)) {
              return true; // Duplicate value found
          }
          valueSet.add(value);
      }
  }

  return false; // No duplicate values
}

function removeDuplicateValues(arr) {
  const uniqueValuesMap = new Map();

  // Iterate through the array and store unique values in the map
  arr.forEach(({ key, value }) => {
    uniqueValuesMap.set(value, { key, value });
  });

  // Convert the unique values map back to an array
  const uniqueValuesArray = Array.from(uniqueValuesMap.values());

  return uniqueValuesArray;
}

module.exports = cds.service.impl(function () {
  const { Student,Gender,Courses,Books} = this.entities();

  this.on(["READ"], Student, async (req) => {
    results = await cds.run(req.query);
    if (Array.isArray(results)) {
      results.forEach((element) => {
        element.age = calcAge(element.dob);
        element.gen = element.gender === 'M' ? 'Male' : 'Female'
      });
    } else {
      results.age = calcAge(results.dob);
      results.gen = results.gender === 'M' ? 'Male' : 'Female';
    }
    if (results.gender === 'M') {
      results.gender = 'Male';
    } else if (results.gender === 'F') {
      results.gender = 'Female';
    }
    return results;
  });

  this.before(["CREATE"], Student, async (req) => {
    age = calcAge(req.data.dob);
    if (age < 18 || age > 45) {
      req.error({
        code: "WRONGDOB",
        message: "Student not the right age for school:" + age,
        target: "dob",
      });
    }

    let query1 = SELECT.from(Student).where({ ref: ["email_id"] }, "=", {
      val: req.data.email_id,
    });
    result = await cds.run(query1);
    console.log(result);
    if (result.length > 0) {
      req.error({
        code: "STEMAILEXISTS",
        message: "Student with such email already exists",
        target: "email_id",
      });
    }
  });

  this.before(["UPDATE"], Student, async (req) => {
    const currentRecordId = req.data.ID;
    let query1 = SELECT.from(Student).where({ ref: ["email_id"] }, "=", {
      val: req.data.email_id,
    });
      const result = await cds.run(query1);
      const matchingRecords = result.filter(record => record.ID !== currentRecordId);
      if (matchingRecords.length > 0) {
        req.error({
          code: "STEMAILEXISTS",
          message: "Another student with such email already exists",
          target: "email_id",
        });
      }
   
  });

  this.on('READ',Gender,async(req)=>{
    genders = [
      {"code":"M","description":"Male"},
      {"code":"F","description":"Female"}
    ]
    genders.$count=genders.length;
    return genders;
  });

  this.before(["CREATE"], Courses, async (req) => {
    const existingCourse = await cds.run(SELECT.from(Courses).where({ code: req.data.code }));
        if (existingCourse.length > 0) {
            req.error({
                code: "DUPLICATE_COURSE",
                message: "Course already exists,Enter another course",
                target: "code",
            });
        }
    let courseBooks=req.data.Books;
        if((hasDuplicates(courseBooks))){
          req.error({
            code: "DUPLICATE_COURSE",
            message: "You cannot select same books more than",
            target: "code",
        });
        }
        const DeleteDuplicateBooks=removeDuplicateValues(courseBooks);
        req.data.Books=DeleteDuplicateBooks;
    });

  this.before(["CREATE","UPDATE"], Books, async (req) => {
      const existingBooks = await cds.run(SELECT.from(Books).where({ code: req.data.code }));
      if (existingBooks.length > 0) {
          req.error({
              code: "DUPLICATE_COURSE",
              message: "Same Books alreay Exists",
              target: "code",
          });
      }
    });
   
    this.before(["UPDATE"], Courses, async (req) => {
      let courseBooks=req.data.Books;
      if((hasDuplicates(courseBooks))){
        req.error({
          code: "DUPLICATE_COURSE",
          message: "You cannot select same books mutliple times",
          target: "code",
      });
      }
  });
 });







