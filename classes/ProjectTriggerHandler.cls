public class ProjectTriggerHandler {
	
    public static void preventDeleteIfChildWorklogs(List<Project__c> triggerOld){
        
        //an project record cannot be deleted if any child worklogs exist
    
    	List<Worklog__c> childWorkLogs = [SELECT Id, Project__c FROM Worklog__c WHERE Project__c IN :triggerOld];
    
    	for(Project__c proj : triggerOld){
        	for(Worklog__c wl : childWorkLogs){
            	if(wl.Project__c == proj.id){
                	proj.addError('Cannot delete project with existing child worklogs!');
            	}
        	}
    	}
    
    }
}