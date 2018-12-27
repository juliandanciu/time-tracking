public class AccountTriggerHandler {
	
    public static void preventDeleteIfChildProjects(List<Account> triggerOld){
        
        //An account record cannot be deleted if any child projects exist
    
    	List<Project__c> childProjects = [SELECT Id, Account__c FROM Project__c WHERE Account__c IN :triggerOld];
    
    	for(Account acct : triggerOld){
        	for(Project__c proj : childProjects){
            		if(proj.Account__c == acct.Id){
                		acct.addError('Cannot delete account with child projects!');
            		}
        	}
    	}
    }
}
