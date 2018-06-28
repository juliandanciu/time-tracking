trigger AccountTriggerAll on Account (before delete) {

    if(Trigger.isDelete){
        if(Trigger.isBefore){
            AccountTriggerHandler.preventDeleteIfChildProjects(trigger.old);
        }
    }
}