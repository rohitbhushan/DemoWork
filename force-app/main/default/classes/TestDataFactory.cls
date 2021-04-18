/* =========================================================================================================
 Description : This class handles test data creation while running test classes
 Created By : Rohit Bhushan

 =========================================================================================================*/
@isTest
public with sharing class TestDataFactory {
    
    public static Lead createLead(String lastname , String lEmail, String cName , String Status ){
        Lead ld = new Lead();
        ld.lastname = lastname;
        ld.email = lEmail;
        ld.Company	 = cName;
        ld.Status = Status;
        return ld;
    }

    public static Contact createContact(String lastname , String cEmail ){
        Contact cn = new Contact();
        cn.lastname = lastname;
        cn.email = cEmail;
       return cn;
    }

    public static Account createAccount(String accName , String secondaryOwnerId ){
        Account acc = new Account();
        acc.Name = accName;
        acc.Secondary_Team_Manager__c = secondaryOwnerId;
       return acc;
    }
}
