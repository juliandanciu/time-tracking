trigger ProjectTriggerAll on Project__c (before delete) {

    if(Trigger.isDelete){
        if(Trigger.isBefore){
            ProjectTriggerHandler.preventDeleteIfChildWorklogs(Trigger.old);
        }
    }
}