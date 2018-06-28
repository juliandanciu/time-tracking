public with sharing class WorklogController {

    @AuraEnabled
    public static Worklog__c insertSingleWorklog(Datetime startTime, Datetime endTime, Id timesheetId, String projectName, String status, String description){
        
        //do some stuff with project Name to get project ID
        Project__c proj = [SELECT Id FROM Project__c WHERE Name = :projectName LIMIT 1];
        Id projectId = proj.Id;
        
        
        Worklog__c w = new Worklog__c();
        w.Start_Time__c = startTime;
        w.End_Time__c = endTime;
        w.Timesheet__c = timesheetId;
        w.Project__c = projectId;
        w.Status__c = status;
        W.Description__c = description;
        
        
        insert(w);
        
        
        
        Worklog__c wl = [SELECT Id, Name, Start_Time__c, End_Time__c, Timesheet__c, Project__c, Project__r.Name, Status__c, Description__c 
                         FROM Worklog__c 
                         WHERE Start_Time__c = :startTime AND End_Time__c = :endTime];
        
        
        return wl; 
        
        
    }
    
    @AuraEnabled
    public static Worklog__c updateSingleWorklog(Worklog__c editWorklog, Datetime startTime, Datetime endTime, String projectName, String description){
        
        Project__c proj = [SELECT Id FROM Project__c WHERE Name = :projectName LIMIT 1];
        Id projectId = proj.Id;
        
        editWorklog.Start_Time__c = startTime;
        editWorklog.End_Time__c = endTime;
        editWorklog.Project__c = projectId;
        editWorklog.Description__c = description;
        
        
        
        update editWorklog;
        
        
        
        return editWorklog;
    }
}