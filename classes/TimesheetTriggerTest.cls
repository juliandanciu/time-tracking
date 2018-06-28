@isTest
public class TimesheetTriggerTest {
	
    @isTest
    static void mondayStartDateTest(){
        
        //create some Timesheets some that start on monday and some that do not 
        List<Timesheet__c> testTimeSheets = new List<Timesheet__c>();
        Timesheet__c mondayTimesheet = new Timesheet__c(Start_Date__c = Date.newInstance(2017, 11, 27),
                                                       Status__c = 'New');
        Timesheet__c tuesdayTimesheet = new Timesheet__c(Start_Date__c = Date.newInstance(2017, 11, 28),
                                                       Status__c = 'New');
        
        
        testTimeSheets.add(mondayTimesheet);
        testTimeSheets.add(tuesdayTimesheet);
        
        List<Database.SaveResult> results = Database.insert(testTimeSheets, false);
        
        System.assert(results.get(0).isSuccess());
        System.assert(!results.get(1).isSuccess());
        System.assertEquals('Start Day must be a Monday!', results.get(1).getErrors().get(0).getMessage());
    }
    
    @isTest
    static void enforceNoEditIfSubmitted(){
        
        //create two Timesheets some that start on monday and some that do not 
        List<Timesheet__c> testTimeSheets = new List<Timesheet__c>();
        Timesheet__c newTimesheet = new Timesheet__c(Start_Date__c = Date.newInstance(2017, 12, 4),
                                                       Status__c = 'New');
        Timesheet__c submittedTimesheet = new Timesheet__c(Start_Date__c = Date.newInstance(2017, 12, 4),
                                                       Status__c = 'Submitted');
        
        
        testTimeSheets.add(newTimesheet);
        testTimeSheets.add(submittedTimesheet);
        
        Database.insert(testTimeSheets, false);
        
        testTimeSheets.get(0).Start_Date__c = Date.newInstance(2017, 12, 11);
        testTimeSheets.get(1).Start_Date__c = Date.newInstance(2017, 12, 11);
        
        List<Database.SaveResult> results = Database.update(testTimeSheets, false);
        
        System.assert(results.get(0).isSuccess());
        System.assert(!results.get(1).isSuccess());
        System.assertEquals('You cannot edit this field while SUBMITTED!', results.get(1).getErrors().get(0).getMessage()); 
        
        
        
    }
    
    
    @isTest
    static void statusCorrespondsTest(){
        
        //create and insert time sheet 
        Timesheet__c testTimeSheet = new Timesheet__c(Start_Date__c = Date.newInStance(2017, 11, 20),
                                                     Status__c = 'New');
        insert testTimeSheet;
        
        //create and insert account
        Account testAccount = new Account(Name = 'TestAccount');
        insert testAccount;
        
        //create and insert project
        Project__c testProject = new Project__c(Name = 'Testing Project',
                                               Description__c = 'Testing Project Description',
                                               Account__c = testAccount.id);
        insert testProject;
        
        List<Worklog__c> childTestWorklogs = new List<Worklog__c>();
        
        for(Integer i = 1; i < 4; i++){
            Worklog__c newWorkLog = new Worklog__c(Start_Time__c = Datetime.newInstance(2017, 11, 21, i, 0, 0),
                                                  End_Time__c = Datetime.newInstance(2017, 11, 21, i, 30, 0),
                                                  Description__c = 'Testing',
                                                  Status__c = 'New',
                                                  Timesheet__c = testTimeSheet.id,
                                                   Project__c = testProject.id );
            childTestWorklogs.add(newWorkLog);
        }
        insert childTestWorklogs;
        
        testTimeSheet.Status__c = 'Submitted';
        update testTimeSheet;
        
        
        for(Worklog__c wl : [SELECT Status__c FROM Worklog__c WHERE Description__c = 'Testing']){
            System.assertEquals('Submitted', wl.Status__c);
            
        }
        
        testTimeSheet.Status__c = 'New';
        update testTimeSheet;
        
        for(Worklog__c wl : [SELECT Status__c FROM Worklog__c WHERE Description__c = 'Testing']){
            System.assertEquals('New', wl.Status__c);
            
        }
    }
}