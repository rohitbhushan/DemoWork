/* =========================================================================================================
 Description : This class brings the data of Lead and Contact from searched key on UI of LWC Consent Page
 Created By : Rohit Bhushan

 =========================================================================================================*/
public with sharing class ConsentPageController {
    @AuraEnabled
    public static List<sObject> getData(String searchKey){
        List<sObject> finList = new List<sObject>();
        String searchquery1 ='FIND ';
        String searchquery2 = ' IN Email FIELDS RETURNING Lead( ';
        String fields = label.Consent_query;
        String searchquery3 = ' ),Contact( ';
        String searchquery4 = ' ) ';
        String qt = '\'';
        String finalQuery = searchquery1 + qt + searchKey +qt + searchquery2 + fields + searchquery3 + fields + searchquery4;
        List<List<SObject>>searchList = search.query(finalQuery);
        finList.addAll(searchList[0]);
        finList.addAll(searchList[1]);
       
        return finList;
    }
   
}
