/* =========================================================================================================
 Description : This class handles the Account Team member creation logic with Owner and secondary owner custom owner field
 Created By : Rohit Bhushan

 =========================================================================================================*/
public with sharing class AccountTriggerHelper {
    
    // to get all Sales rep for owner or secondary owner
    public static Map<String,List<String>> getSalesReps(List<String> accManagerIdList){
        Map<String,List<String>> managerIdSalesRepIdListMap = new Map<String,List<String>>();
        List<String> repIdList = new List<String>();
        //salesRepList = [Select Id , ManagerId from User WHERE ManagerId = :accManagerIdList ];
        for(User uId : [Select Id , ManagerId from User WHERE ManagerId = :accManagerIdList] ){
            repIdList.add(uId.ManagerId);
            if(! managerIdSalesRepIdListMap.containsKey(uId.ManagerId)){
                managerIdSalesRepIdListMap.put(uId.ManagerId, new List<String>{ uId.id});
            }else{
                List<String> temp = managerIdSalesRepIdListMap.get(uId.ManagerId);
                temp.add(uId.Id);
                managerIdSalesRepIdListMap.put(uId.ManagerId, temp);
            }
        }
        return managerIdSalesRepIdListMap;
    }

    // to prepare mapping for Account and Sales rep needs to be added on Account TEam member
    public static  Map<String,List<String>> addAccTeamMember(Map<String,String> accIdOwnerIdMap ,Map<String,List<String>> salesRepUserIdList){
        Map<String,List<String>> accIdTeamMemeberListMap = new Map<String,List<String>>();
        for(String accId : accIdOwnerIdMap.keySet()){
            List<String> teamMemberIdList = salesRepUserIdList.get(accIdOwnerIdMap.get(accId));
            if(! accIdTeamMemeberListMap.containskey(accId)){
                accIdTeamMemeberListMap.put(accId ,teamMemberIdList);
            }else{
                List<String> temp = accIdTeamMemeberListMap.get(accId);
                temp.addAll(teamMemberIdList);
                accIdTeamMemeberListMap.put(accId,temp);
            }
        }
        return accIdTeamMemeberListMap;
    }

    // do DML for Account Team Member for Account wrt to Owner and Secondary owner
    public static void insertAccTeamMember( Map<String,List<String>> mapOfAccIdTeamMemberToBeAdded, Boolean IsSecondaryOwnerChange){
        List<AccountTeamMember> atmList = new List<AccountTeamMember>();
        for(String accId : mapOfAccIdTeamMemberToBeAdded.keySet()){
            for(String userId : mapOfAccIdTeamMemberToBeAdded.get(accId)){
                AccountTeamMember atm = new AccountTeamMember();
                atm.AccountId = accId;
                atm.UserId = userId;
                if(IsSecondaryOwnerChange){
                    atm.TeamMemberRole = 'Sales Rep';
                    atm.AccountAccessLevel = 'Read';
                }else{
                    atm.TeamMemberRole = 'Account Manager';
                    atm.AccountAccessLevel = 'Edit';
                }
                
                atm.ContactAccessLevel = 'None';
                atm.OpportunityAccessLevel = 'None';
                atm.CaseAccessLevel = 'None';
                atmList.add(atm);
            }
        }
        system.debug('atmList: '+ atmList);
        try{
            insert atmList;
        }catch(Exception e){
            system.debug('Error: '+e.getMessage());
            
        }
    }
}
