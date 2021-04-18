@isTest
public with sharing class AccountTriggerHandler_Test {
    
    @TestSetup
    static void makeData(){
        String profId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id;
        List<User> ulist = new List<User>();
        UserRole ur1 = new UserRole(Name = 'Account_Manager');
        UserRole ur2 = new UserRole(Name = 'Sales_Rep');
        List<UserRole> userRoleList = new List<UserRole>{ur1, ur2};
        Insert userRoleList;
        List<Account> accList = new List<Account>();
        User accManager = new User(  firstname = 'fNameM',
                                lastName = 'lNameM',
                                email = 'fNameM' + 'lNameM' + '@test' + 'orgId' + '.org',
                                Username = 'fNameM' + 'lNameM' + '@test' + '.org',
                                EmailEncodingKey = 'ISO-8859-1',
                                Alias = 'lNameM',
                                TimeZoneSidKey = 'America/Los_Angeles',
                                LocaleSidKey = 'en_US',
                                LanguageLocaleKey = 'en_US',
                                ProfileId = profId,
                                UserRoleId = ur1.Id);
                                
        insert accManager;
        User salesRep1 = new User(  firstname = 'fNameSP',
                                lastName = 'lNameSP',
                                email = 'fNameSP' + 'lNameSP' +  '@test' + 'orgId' + '.org',
                                Username = 'fNameSP' +'lNameSP' + '@test'  + '.org',
                                EmailEncodingKey = 'ISO-8859-1',
                                Alias = 'lNameSP',
                                TimeZoneSidKey = 'America/Los_Angeles',
                                LocaleSidKey = 'en_US',
                                LanguageLocaleKey = 'en_US',
                                ProfileId = profId,
                                ManagerId = accManager.Id,
                                UserRoleId = ur2.Id);
        User salesRep2 = new User(  firstname = 'fNameSP2',
                                lastName = 'lNameSP2',
                                email = 'fNameSP2' + 'lNameSP2' +  '@test' + 'orgId' + '.org',
                                Username = 'fNameSP2' +'lNameSP2' + '@test'  + '.org',
                                EmailEncodingKey = 'ISO-8859-1',
                                Alias = 'lNameSP2',
                                TimeZoneSidKey = 'America/Los_Angeles',
                                LocaleSidKey = 'en_US',
                                LanguageLocaleKey = 'en_US',
                                ProfileId = profId,
                                ManagerId = accManager.Id,
                                UserRoleId = ur2.Id);
        ulist.add(salesRep1);
        ulist.add(salesRep2);
        insert ulist;
        System.runAs(accManager){
            for(Integer i = 0 ; i < 5 ; i++){
                accList.add(TestDataFactory.createAccount('accName'+ i, null));
            }    

            insert accList;
        }
    
    }

    @isTest
    public static void ownerHandler_test(){
        List<Account> accList = new List<Account>();
        List<AccountTeamMember> atm = new List<AccountTeamMember>();
        atm = [Select Id , AccountAccessLevel from AccountTeamMember ];
        String userId = [Select Id from User where FirstName = 'fNameM' limit 1].Id;
        system.assertEquals(5, atm.size(), '5 records inserted for Account Team member');
        system.assertEquals('Edit', atm[0].AccountAccessLevel, '5 records inserted for Account Team member with EDIT access');
        for(Integer i = 0 ; i < 2 ; i++){
            accList.add(TestDataFactory.createAccount('accName'+ i, null));
        }    

        insert accList;
        Test.startTest();
        accList[0].ownerId = userId;
        accList[1].ownerId = userId;
        update accList;
        atm = [Select Id , AccountAccessLevel from AccountTeamMember ];
        Test.stopTest();
        system.assertEquals(7, atm.size(), 'One record inserted for Account Team member');
        system.assertEquals('Edit', atm[6].AccountAccessLevel, 'One record inserted for Account Team member with EDIT access');
    }

    @isTest
    public static void secondaryOwnerHandler_test(){
        List<Account> accList = new List<Account>();
        List<AccountTeamMember> atm = new List<AccountTeamMember>();
       // atm = [Select Id , AccountAccessLevel from AccountTeamMember ];
        String userId = [Select Id from User where FirstName = 'fNameM' limit 1].Id;
       // system.assertEquals(5, atm.size(), '5 records inserted for Account Team member');
       // system.assertEquals('Edit', atm[0].AccountAccessLevel, '5 records inserted for Account Team member with EDIT access');
        for(Integer i = 8 ; i < 10 ; i++){
            accList.add(TestDataFactory.createAccount('accName'+ i, userId));
        }    

        
        Test.startTest();
        insert accList;
        atm = [Select Id , AccountAccessLevel, Account.Name from AccountTeamMember where Account.Name IN ('accName8', 'accName9')];
        Test.stopTest();
        system.assertEquals(2, atm.size(), '2 records inserted for Account Team member');
        system.assertEquals('Read', atm[0].AccountAccessLevel, '2 records inserted for Account Team member with READ access');
    }
   
}
