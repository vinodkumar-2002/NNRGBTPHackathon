using { com.satinfotech.studentdb as db } from '../db/schema';

service StudentDB {
    entity Student as projection on db.Student;
    entity BusinessPartner as projection on db.BusinessPartner;
    entity Gender as projection on db.Gender;
    entity Languages as projection on db.Languages{
        @UI.Hidden: true
        ID,
        *
    };
    entity Courses as projection on db.Courses{
        @UI.Hidden: true
        ID,
        *
    };
    entity Books as projection on db.Books{
        @UI.Hidden: true
        ID,
        *
    };
}

annotate StudentDB.Student with @odata.draft.enabled;
annotate StudentDB.BusinessPartner with @odata.draft.enabled;
annotate StudentDB.Courses with @odata.draft.enabled;
annotate StudentDB.Languages with @odata.draft.enabled;
annotate StudentDB.Books with @odata.draft.enabled;

annotate StudentDB.Student with {
    first_name      @assert.format: '^[a-zA-Z]{2,}$';
    last_name      @assert.format: '^[a-zA-Z]{2,}$';    
    email_id     @assert.format: '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    pan_no       @assert.format: '^[A-Z]{5}[0-9]{4}[A-Z]$';
    //telephone @assert.format: '^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$';
}

annotate StudentDB.BusinessPartner with {

    name      @assert.format: '^[a-zA-Z ]{2,}$' ;  
    // State      @assert.format: '^[a-zA-Z]{2}$' ; 
    // PINCode    @assert.format: '^[0-9]{6}$'     ;
    // is_gstin_registered @assert.inclusion: [true, false]  ;
    // is_vendor           @assert.inclusion: [true, false]  ;
    // is_customer         @assert.inclusion: [true, false] ;
    

}

annotate BusinessPartner with @( 
    UI.LineItem: [ // Define the order of displaying the data in a table
        {
            $Type: 'UI.DataField',
            Value: bpno // Display BusinessPartnerNumber
        },
        {
            $Type: 'UI.DataField',
            Value: name // Display Name
        },
        {
            $Type: 'UI.DataField',
            Value: Address1 // Display Address1
        },
        {
            $Type: 'UI.DataField',
            Value: Address2 // Display Address2
        },
        {
            $Type: 'UI.DataField',
            Value: City // Display City
        },
        {
            $Type: 'UI.DataField',
            Value: State // Display State
        },
        {
            $Type: 'UI.DataField',
            Value: PINCode // Display PINCode
        },
        {
            $Type: 'UI.DataField',
            Value: is_gstin_registered // Display is_gstin_registered
        },
        {
            $Type: 'UI.DataField',
            Value: is_vendor // Display is_vendor
        },
        {
            $Type: 'UI.DataField',
            Value: is_customer // Display is_customer
        },
    ],
    UI.SelectionFields: [ bpno, name, Address1, Address2, City, State, PINCode ], // Define fields for selection
    UI.FieldGroup #BusinessPartnerInformation: { // Define a field group for input
        $Type: 'UI.FieldGroupType',
        Data: [
            {
                $Type: 'UI.DataField',
                Value: bpno, // BusinessPartnerNumber input field
            },
            {
                $Type: 'UI.DataField',
                Value: name, // Name input field
            },
            {
                $Type: 'UI.DataField',
                Value: Address1, // Address1 input field
            },
            {
                $Type: 'UI.DataField',
                Value: Address2, // Address2 input field
            },
            {
                $Type: 'UI.DataField',
                Value: City, // City input field
            },
            {
                $Type: 'UI.DataField',
                Value: State, // State input field
            },
            {
                $Type: 'UI.DataField',
                Value: PINCode, // PINCode input field
            },
            {
                $Type: 'UI.DataField',
                Value: is_gstin_registered, // is_gstin_registered input field
            },
            {
                $Type: 'UI.DataField',
                Value: is_vendor, // is_vendor input field
            },
            {
                $Type: 'UI.DataField',
                Value: is_customer, // is_customer input field
            },
        ],
    },
    UI.Facets: [ // Define UI facets
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'BusinessPartnerInfoFacet',
            Label: 'Business Partner Information',
            Target: '@UI.FieldGroup#BusinessPartnerInformation', // Target the field group for display
        },
    ],
);


annotate StudentDB.Languages with @(
    UI.LineItem:[
        {
            Value: code
        },
        {
            Value: description
        }
    ],
     UI.FieldGroup #Languages : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                Value : code,
            },
            {
                Value : description,
            }
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'LanguagesFacet',
            Label : 'Languages',
            Target : '@UI.FieldGroup#Languages',
        },
    ],

);


annotate StudentDB.Student.Languages with @(
    UI.LineItem:[
        {
            Label: 'Languages',
            Value: lang_ID
        },
      
    ],
    UI.FieldGroup #StudentLanguages : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {                                               
                Value : lang_ID,
            }
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'LanguagesFacet',
            Label : 'Languages',
            Target : '@UI.FieldGroup#StudentLanguages',
        },
      
    ],
);


annotate StudentDB.Courses with @(
    UI.LineItem:[
        {
            Value: code
        },
        {
            Value: description
        },
        {   
            Label:'Course Books',
            Value: Books.book.description
        }
    ],
     UI.FieldGroup #Courses : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                Value : code,
            },
            {
                Value : description,
            },
            // {
            //     Value :book_ID
            // },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'CoursesFacet',
            Label : 'Courses',
            Target : '@UI.FieldGroup#Courses',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'StudentCourseFacet',
            Label : 'Course Books Information',
            Target : 'Books/@UI.LineItem',
        },
    ],

);

annotate StudentDB.Courses.Books with @(
    UI.LineItem:[
        {
            Label: 'Books',
            Value: book_ID
        },
      
    ],
    UI.FieldGroup #StudentCourses: {
        $Type : 'UI.FieldGroupType',
        Data : [
            {                                               
                Value : book_ID,
            }
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'CoursesFacet',
            Label : 'Courses',
            Target : '@UI.FieldGroup#StudentCourses',
        },
    ],
);


annotate StudentDB.Books with @(
    UI.LineItem:[
        {
            Value: code
        },
        {
            Value: description
        }
    ],
     UI.FieldGroup #Books : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                Value : code,
            },
            {
                Value : description,
            }
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'BooksFacet',
            Label : 'Books',
            Target : '@UI.FieldGroup#Books',
        },
    ],

);

annotate StudentDB.Gender with @(
UI.LineItem: [
        {
            @Type : 'UI.DataField',
            Value : code
        },
        {
            @Type : 'UI.DataField',
            Value : description
        },

],
);
annotate StudentDB.Student with @( 
    UI.LineItem: [ //the order of displaying the data in the form of table
        {
            $Type : 'UI.DataField',
            Value : studentid
        },
        {
            $Type : 'UI.DataField',
            Value : first_name
        },
        {
            $Type : 'UI.DataField',
            Value : last_name
        },
        {
            $Type : 'UI.DataField',
            Label :'Gender',  // label for display
            Value : gen   // the value that is display on the table
        },
        {
            $Type : 'UI.DataField',
            Value : email_id
        },
        {
            $Type : 'UI.DataField',
            Value : pan_no
        },
        {
           // $Type : 'UI.DataField',
            Value : course.code
        },
        {
            $Type : 'UI.DataField',
            Value : dob
        },
        {
            $Type : 'UI.DataField',
            Value : age
        },
        {
            $Type : 'UI.DataField',
            Value : is_alumni
        },

    ],
    UI.SelectionFields: [ studentid ,first_name, last_name, email_id , pan_no,dob,age],       
    UI.FieldGroup #StudentInformation : { // used to take input
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : studentid,
            },
            {
                $Type : 'UI.DataField',
                Value : first_name,
            },
            {
                $Type : 'UI.DataField',
                Value : last_name,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Gender',
                Value : gender,  // the value that is taken , it can be either as "F" or "M"
            },
            {
                $Type : 'UI.DataField',
                Value : email_id,
            },
            {
                $Type : 'UI.DataField',
                Value : pan_no,
            },
             {
                $Type : 'UI.DataField',
                Value : course_ID,//taken value
            },
            {
                $Type : 'UI.DataField',
                Value : dob,
            },

        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'StudentInfoFacet',
            Label : 'Student Information',
            Target : '@UI.FieldGroup#StudentInformation',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'StudentLanguagesFacet',
            Label : 'Student Languages Information',
            Target : 'Languages/@UI.LineItem',
        },
        
    ],
    
);



annotate StudentDB.Student.Languages with {
    lang @(
        Common.Text: lang.description,
        Common.TextArrangement: #TextOnly,
        Common.ValueListWithFixedValues: true,
        Common.ValueList : {
            Label: 'Languages',
            CollectionPath : 'Languages',
            Parameters: [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : lang_ID,
                    ValueListProperty : 'ID'
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'code'
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'description'
                },
            ]
        }
    );
}

annotate StudentDB.Courses.Books with {
    book @(
        Common.Text: book.description,
        Common.TextArrangement: #TextOnly,
        Common.ValueListWithFixedValues: true,
        Common.ValueList : {
            Label: 'Books',
            CollectionPath : 'Books',
            Parameters: [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : book_ID,
                    ValueListProperty : 'ID'
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'code'
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'description'
                },
            ]
        }
    );

}



annotate StudentDB.Student with {
    gender @(     
        Common.ValueListWithFixedValues: true,
        Common.ValueList : {
            Label: 'Genders',
            CollectionPath : 'Gender',
            Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : gender,
                    ValueListProperty : 'code'
                },
               
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'description'
                }
            ]
        }
    );
    course @(
        Common.Text: course.description,
        Common.TextArrangement: #TextOnly,
        Common.ValueListWithFixedValues: true,
        Common.ValueList : {
            Label: 'Courses',
            CollectionPath : 'Courses',
            Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : course_ID,
                    ValueListProperty : 'ID'
                },
               
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'code'
                },
                   {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'description'
                }
            ]
        }
    )
}