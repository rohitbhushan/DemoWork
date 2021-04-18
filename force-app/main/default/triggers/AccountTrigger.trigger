trigger AccountTrigger on Account (after insert, after update) {
    ToByPassTrigger__c toByPass = ToByPassTrigger__c.getInstance(
        UserInfo.getUserId()
    );
    if (
        toByPass != null &&
        toByPass.Object__c != null &&
        (toByPass.Object__c.contains('Account') && toByPass.IsDisable__c)
    ) {
        System.debug('Account trigger disabled');
    } else {
        System.debug('Account trigger enabled');
        if (Trigger.isAfter) {
            if (Trigger.IsInsert) {
                AccountTriggerHandler.ownerHandler(Trigger.new, null);
                AccountTriggerHandler.secondaryOwnerHandler(Trigger.new, null);
            }
            if (Trigger.IsUpdate) {
            AccountTriggerHandler.ownerHandler(Trigger.new, Trigger.oldMap);
            AccountTriggerHandler.secondaryOwnerHandler(Trigger.new, Trigger.oldMap);
            }
        }
        
    }
}   