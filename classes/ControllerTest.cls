@isTest
public class ControllerTest {
	
    @isTest
    public static void insertSingleWorklogTest_checkIfInsertWorks_success(){
        
        //test setup
        Id tsId = ControllerTestFactory.initControllerTest();
        
        Datetime startTime = Datetime.newInstance(2017, 11, 22, 11, 30, 0);
        Datetime endTime = Datetime.newInstance(2017, 11, 22, 13, 30, 0);
        Id timesheetId = tsId;
        String projectName = 'Test Project';
        String status = 'New';
        String description = 'testing 123';
        
        //run the test 
        System.Test.startTest();
        Worklog__c myWorklog = WorklogController.insertSingleWorklog(startTime, endTime, timesheetId, 
                                              projectName, status, description);
        System.Test.stopTest();
        
        //assertions
        System.assertEquals(startTime, myWorklog.Start_Time__c);
        
    }
    
    @isTest
    public static void updateSingleWorklogTest_checkIfUpdateWorks_success(){
        
        //create wl to update
        Worklog__c wl = ControllerTestFactory.initControllerTestUpdate();
        
        //update with the following new properties (simulating the UI form)
        Datetime startTime = Datetime.newInstance(2017, 11, 22, 11, 30, 0);
        Datetime endTime = Datetime.newInstance(2017, 11, 22, 13, 30, 0);
        Id timesheetId = wl.Timesheet__c;
        String projectName = 'Test Project';
        String status = 'New';
        String description = 'testing update 123';
        

        System.Test.startTest();
        Worklog__c myWorklogUpdate = WorklogController.updateSingleWorklog(wl, startTime, endTime, projectName, description);
		System.Test.stopTest();
        
        System.assertEquals('testing update 123', myWorklogUpdate.Description__c);
    }
    
    @isTest
    public static void queryTimesheetTest_checkExistingAndNew(){
        
        Timesheet__c ts = ControllerTestFactory.initQueryTimesheetTest();
        Date myDateExisting = ts.Start_Date__c;
        Date myDateNew = Date.newInstance(2017, 12, 11);
        
        String myDateStringExisting = '2017-11-20';
        String myDateStringNew = '2017-12-11';
        //Id myId = UserInfo.getUserId();
        
        Test.startTest();
        Timesheet__c testTimesheet0 = TimesheetController.queryTimesheet(myDateStringExisting);
        Timesheet__c testTimesheet1 = TimesheetController.queryTimesheet(myDateStringNew);
        Test.stopTest();
        
        System.assertEquals(myDateExisting, testTimesheet0.Start_Date__c);
        System.assertEquals(myDateNew, testTimesheet1.Start_Date__c);
    }
    
    @isTest
    public static void submitTimesheetTest_checkSubmission_success(){
        
        Timesheet__c ts = ControllerTestFactory.initSubmitTimesheetTest();
        System.assertEquals('New', ts.Status__c);
        
        Test.startTest();
        Timesheet__c submittedTimesheet = TimesheetController.submitTimesheet(ts);
        Test.stopTest();
        
        System.assertEquals('Submitted', submittedTimesheet.Status__c);
       
    }
    
    @isTest
    public static void deleteSelectedWorklogsTest_checkDeletion_success(){
        
        List<Id> selectedWorklogs = ControllerTestFactory.initDeleteSelectedWorklogsTest();
        
        
        Test.startTest();
        List<Worklog__c> deletedWorklogs = TimesheetController.deleteSelectedWorklogs(selectedWorklogs);
        Test.stopTest();
        
        System.assertEquals(selectedWorklogs[0], deletedWorklogs[0].Id);
       
    }
    
    
}