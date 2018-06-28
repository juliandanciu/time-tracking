public with sharing class TimesheetController {
	
    @AuraEnabled
    public static Timesheet__c queryTimesheet(String dateValue){
       
        
        Date myDate = Date.valueOf(dateValue);
        System.debug(myDate);
        Id myId = UserInfo.getUserId();
        
        try{
        	Timesheet__c timesheet = [SELECT Id, Name, Start_Date__c, User__r.Name, Status__c, 
                                    (SELECT Name, Project__r.Name, Start_Time__c, End_Time__c, Description__c, Status__c 
                                     FROM Worklogs__r ORDER BY Name ) FROM Timesheet__c WHERE Start_Date__c = :myDate 
                                      AND User__c = :myId LIMIT 1];
            
        	return timesheet;
        } catch (QueryException e){
            
            Timesheet__c newTimesheet = new Timesheet__c(Start_Date__c = myDate,
                                                        Status__c = 'New',
                                                        User__c = UserInfo.getUserId());
            insert newTimesheet;
            Timesheet__c timesheet = [SELECT Id, Name, Start_Date__c, User__r.Name, Status__c, 
                                    (SELECT Name, Project__r.Name, Start_Time__c, End_Time__c, Description__c, Status__c 
                                     FROM Worklogs__r ) FROM Timesheet__c WHERE ID = :newTimesheet.Id LIMIT 1];
            
        	return timesheet;
            
        } 
            
        
        
        
        

    }
    
    
    
    @AuraEnabled
    public static Timesheet__c submitTimesheet(Timesheet__c timesheet){
       //query for the timesheet
       System.debug('Star Wars 2');
        Timesheet__c timesheetToUpdate = [SELECT Id, Status__c FROM Timesheet__c WHERE Id = :timesheet.Id LIMIT 1];
        
        timesheetToUpdate.Status__c = 'Submitted';
        update timesheetToUpdate;
        System.debug('Star Wars 4');
        Timesheet__c timesheetToUpdateNew = [SELECT Id, Name, Start_Date__c, User__r.Name, Status__c, 
                                    (SELECT Name, Project__r.Name, Start_Time__c, End_Time__c, Description__c, Status__c 
                                     FROM Worklogs__r ORDER BY Name) FROM Timesheet__c WHERE Id = :timesheet.Id LIMIT 1];
        return timesheetToUpdateNew; 
        
      
	}
    
    @AuraEnabled
    public static List<Worklog__c> deleteSelectedWorklogs(List<Id> selectedWorklogs){
        
        List<Worklog__c> toDelete = [SELECT Id FROM Worklog__c WHERE Id In :selectedWorklogs];
        
        delete toDelete; 
        
        
        return toDelete;
        
        
    }
}