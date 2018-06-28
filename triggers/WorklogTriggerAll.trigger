trigger WorklogTriggerAll on Worklog__c (before insert, after insert, before update, after update, before delete, after delete) {
	
    if(Trigger.isInsert){
        if(Trigger.isBefore){
            WorklogTriggerHandler.checkOverlapInsert(trigger.new);
          
        } else if(Trigger.isAfter){
            WorklogTriggerHandler.editParentTimesheetAccordinglyCreate(trigger.new, trigger.oldMap, trigger.newMap);
        } 
       
        
    } else if (Trigger.isUpdate){
        if(Trigger.isBefore){
           WorklogTriggerHandler.editSubmittedWorklog(trigger.new, trigger.oldMap, trigger.newMap);
            WorklogTriggerHandler.checkOverlapUpdate(trigger.new, trigger.oldMap, trigger.newMap);
        } else if(Trigger.isAfter){
            WorklogTriggerHandler.editParentTimesheetAccordingly(trigger.new, trigger.oldMap, trigger.newMap);
        }
        
    } else if (Trigger.isDelete){
        if(Trigger.isBefore){
            WorklogTriggerHandler.submittedWorklogsCannotBeDeleted(Trigger.old);
            
        } else if (Trigger.isAfter){
            WorklogTriggerHandler.editParentTimesheetAccordinglyDelete(trigger.old, trigger.oldMap, trigger.newMap);
        }
    }
    
}