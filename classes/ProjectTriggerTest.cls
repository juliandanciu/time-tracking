@isTest
public class ProjectTriggerTest {
	
    @isTest
    static void projectDeletionTest(){
        //creat project and child worklogs
        
        Account testAcct = new Account(Name = 'Test Account');
        insert testAcct;
        
        List<Project__c> testProjects = new List<Project__c>();
        
        Project__c successProject = new Project__c(Name = 'Success Project',
                                               Description__c = 'Success Project Description',
                                               Account__c = testAcct.id);
        
        Project__c failProject = new Project__c(Name = 'Fail Project',
                                               Description__c = 'Fail Project Description',
                                               Account__c = testAcct.id);
        
        testProjects.add(successProject);
        testProjects.add(failProject);
        insert testProjects;
        
        //create and insert time sheet 
        Timesheet__c testTimeSheet = new Timesheet__c(Start_Date__c = Date.newInStance(2017, 11, 20),
                                                     Status__c = 'New');
        insert testTimeSheet;
        
        Worklog__c newWorkLog = new Worklog__c(Start_Time__c = Datetime.newInstance(2017, 11, 21, 4, 0, 0),
                                                  End_Time__c = Datetime.newInstance(2017, 11, 21, 4, 30, 0),
                                                  Description__c = 'Testing',
                                                  Status__c = 'New',
                                                  Timesheet__c = testTimeSheet.id,
                                                   Project__c = testProjects.get(1).id );
        insert newWorkLog;
        
        List<Database.DeleteResult> results = Database.delete(testProjects , false);
        
        System.assert(results.get(0).isSuccess());
        System.assert(!results.get(1).isSuccess());
        System.assertEquals('Cannot delete project with existing child worklogs!', results.get(1).getErrors().get(0).getMessage());
            
    }
}