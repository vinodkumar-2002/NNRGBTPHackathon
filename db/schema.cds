namespace com.satinfotech.studentdb;

using {managed, cuid} from '@sap/cds/common';



entity BusinessPartner {
    key bpno : String(15) @title :'BusinessPartnerNumber';
    @title : 'Name'
    name : String(40) @mandatory;
    @title : 'Address1'
    Address1 : String(40) @mandatory;
    @title : 'Address2'
    Address2 : String(6);
    @title : 'City'
    City : String(40) @mandatory;
    @title : 'State'
    State : String(10);
    @title : 'PINCode'
    PINCode : String(6) @mandatory;
    @title : 'is_gstin_registered'
    is_gstin_registered : Boolean default false;
    @title : 'is_vendor'
    is_vendor : Boolean default false;
    @title : 'is_customer'
    is_customer : Boolean default false;
}


@assert.unique: {
    studentid:[studentid]
}

entity Student:cuid,managed{
//key ID: UUID;
@title :'StudentID'
studentid: String(5);
 @title :'FirstName'
 first_name: String(40) @mandatory;
 @title :'LastName'
 last_name: String(40) @mandatory;
 @title :'Gender'
 virtual gen : String(6) @Core.Computed;
 @title :'EmailID'
 email_id: String(40) @mandatory;
 @title :'PanNo'
 pan_no : String(10);
 @title : 'Date of Birth'
 dob : Date @mandatory;
 @title : 'Age'
 virtual age :Integer @Core.Computed;
 @title :'Course'
 course : Association to  Courses;
 @title: 'Languages Known'
    Languages: Composition of many {
        key ID: UUID;
        lang: Association to Languages;
    }
 gender : String(1);
 @title:'is_alumni' 
 is_alumni: Boolean default false;
}

@cds.persistence.skip
entity Gender {
 @title:'code'
 key code : String(1);
 @title :'Description'
 description : String(10); 
}

entity Courses : cuid,managed {
@title:'Code'
code: String(3);
@title:'Description'
description: String(50); 
@title:'Course Books'
Books: Composition of many {
    key ID: UUID;
    book: Association to Books;
}
}

entity Languages:cuid,managed {
@title:'Code'
code: String(3);
@title:'Description'
description: String(50);
}

entity Books:cuid,managed {
courses_ID: UUID;
@title:'Code'
code: String(5);
@title:'Description'
description: String(50);
}