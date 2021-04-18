@isTest
public with sharing class ConsentPageController_Test {
    
    @TestSetup
    static void makeData(){
        List<Lead> ldList = new List<Lead>();
        List<Contact> cnList = new List<Contact>();
        for(Integer i =0 ; i < 5 ; i++){
            ldList.add(TestDataFactory.createLead('lastname201'+i, 'testemail@dc.com', 'comp'+i, 'Open-Not Contacted'));
        }
        for(Integer i =0 ; i < 5 ; i++){
            cnList.add(TestDataFactory.createContact('lastname'+i, 'testemail@dc.com') );
        }
        if(ldList.size()>0){
            insert ldList;
        }
        if(cnList.size()>0){
            insert cnList;
        }

    }

    @istest
    public static void getData_Test(){
        List<Contact> con = new List<Contact>();
        con = [Select Id , email from Contact ];
        List<Lead> led = new List<Lead>();
        led = [Select Id, email from Lead ];
        system.debug(' con ' + con.size() +  ' led ' +  led.size());
        List<List<sObject>> ss = [FIND 'testemail@dc.com' IN ALL FIELDS RETURNING Lead( Id,Name,Email )];
        system.debug(' ss@# ' + ss);
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = con[0].Id;
        
        System.Test.setFixedSearchResults(fixedSearchResults);
        Test.startTest();
        List<sObject> newList = ConsentPageController.getData('testemail@dc.com');
        Test.stopTest();
        system.debug('test@ '+ newList.size());
        system.assertEquals(1, newList.size(), '1 record set for SOSL ');
    }
}
