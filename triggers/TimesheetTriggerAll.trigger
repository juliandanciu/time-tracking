trigger TimesheetTriggerAll on Timesheet__c (before insert, before update, after update, before delete) {
	
    if(Trigger.isInsert){
        if(Trigger.isBefore){
           TimesheetTriggerHandler.enforceMondayStartDate(trigger.new);  
        } 
       
        
    } else if (Trigger.isUpdate){
        if(Trigger.isBefore){
           TimesheetTriggerHandler.enforceNoEditIfSubmitted(trigger.new, trigger.oldMap, trigger.newMap);
            TimesheetTriggerHandler.enforceMondayStartDate(trigger.new);
            TimesheetTriggerHandler.cannotChangeIfParent(trigger.new, trigger.oldMap, trigger.newMap);
        } else if (Trigger.isAfter){
            TimesheetTriggerHandler.statusCorresponds(trigger.new, trigger.oldMap);
        }
        
    } else if (Trigger.isDelete){
        if(Trigger.isBefore){
            TimesheetTriggerHandler.submittedTimesheetsCannotBeDeleted(Trigger.old);
        }
    } 
    
}