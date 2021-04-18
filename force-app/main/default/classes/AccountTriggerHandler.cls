/* =========================================================================================================
 Description : This class handles the Account Team member creation logic with Owner and secondary owner custom owner field
 Created By : Rohit Bhushan

 =========================================================================================================*/
public with sharing class AccountTriggerHandler {
    
    
    public static void ownerHandler(List<Account> trgNew, Map<Id,Account> trgOldMap){
        List<String> ownerIdList = new List<String>();
        Map<String,String> accIdOwnerIdMap = new Map<String,String>();
        for(Account acc : trgNew){
            //system.debug('trgOldMap.get(acc.Id).OwnerId: '+ trgOldMap.get(acc.Id).OwnerId +  ' acc.OwnerId: '+ acc.OwnerId);
            if(trgOldMap == null){
                ownerIdList.add(acc.OwnerId);
                if(! accIdOwnerIdMap.containsKey(acc.Id)){
                    accIdOwnerIdMap.put(acc.Id, acc.OwnerId);
                }
            }else{
                if(trgOldMap.get(acc.Id).OwnerId != acc.OwnerId){
                    // logic
                    ownerIdList.add(acc.OwnerId);
                    if(! accIdOwnerIdMap.containsKey(acc.Id)){
                        accIdOwnerIdMap.put(acc.Id, acc.OwnerId);
                    }
                }
            }   
        }
        system.debug('ownerIdList: '+ ownerIdList + 'accIdOwnerIdMap: '+ accIdOwnerIdMap);
        Map<String,List<String>> salesRepUserIdList = AccountTriggerHelper.getSalesReps(ownerIdList);
        if(salesRepUserIdList.keySet().size()>0){
            Map<String,List<String>> mapOfAccIdTeamMemberToBeAdded = AccountTriggerHelper.addAccTeamMember(accIdOwnerIdMap ,salesRepUserIdList);
            system.debug('salesRepUserIdList: '+ salesRepUserIdList + 'mapOfAccIdTeamMemberToBeAdded: '+ mapOfAccIdTeamMemberToBeAdded);
            AccountTriggerHelper.insertAccTeamMember(mapOfAccIdTeamMemberToBeAdded , false);
        }    
    }

    public static void secondaryOwnerHandler(List<Account> trgNew, Map<Id,Account> trgOldMap){
        List<String> secondaryOwnerIdList = new List<String>();
        Map<String,String> accIdSecondOwnerIdMap = new Map<String,String>();
        for(Account acc : trgNew){
            //system.debug('trgOldMap.get(acc.Id).OwnerId: '+ trgOldMap.get(acc.Id).OwnerId +  ' acc.OwnerId: '+ acc.OwnerId);
            if(trgOldMap == null){
                secondaryOwnerIdList.add(acc.Secondary_Team_Manager__c);
                if(! accIdSecondOwnerIdMap.containsKey(acc.Id)){
                    accIdSecondOwnerIdMap.put(acc.Id, acc.Secondary_Team_Manager__c);
                }
            }else{
                if(trgOldMap.get(acc.Id).Secondary_Team_Manager__c != acc.Secondary_Team_Manager__c){
                    // logic
                    secondaryOwnerIdList.add(acc.Secondary_Team_Manager__c);
                    if(! accIdSecondOwnerIdMap.containsKey(acc.Id)){
                        accIdSecondOwnerIdMap.put(acc.Id, acc.Secondary_Team_Manager__c);
                    }
                }
            }   
        }
        system.debug('secondaryOwnerIdList: '+ secondaryOwnerIdList + 'accIdSecondOwnerIdMap: '+ accIdSecondOwnerIdMap);
        Map<String,List<String>> salesRepUserIdList = AccountTriggerHelper.getSalesReps(secondaryOwnerIdList);
        if(salesRepUserIdList.keySet().size()>0){
            Map<String,List<String>> mapOfAccIdTeamMemberToBeAdded = AccountTriggerHelper.addAccTeamMember(accIdSecondOwnerIdMap ,salesRepUserIdList);
            system.debug('salesRepUserIdList: '+ salesRepUserIdList + 'mapOfAccIdTeamMemberToBeAdded: '+ mapOfAccIdTeamMemberToBeAdded);
            AccountTriggerHelper.insertAccTeamMember(mapOfAccIdTeamMemberToBeAdded, true);
        }
    }
}
