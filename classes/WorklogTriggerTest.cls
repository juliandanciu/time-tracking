@isTest
public class WorklogTriggerTest {
	
    @isTest
    public static void checkOverlapTest(){
        Account acct = new Account(Name = 'Test Account');
        insert acct;
        Project__c proj = new Project__c(Name = 'Test Project',
                                        Description__c = 'Test Project Description',
                                        Account__c = acct.Id);
        insert proj;
        Timesheet__c ts = new Timesheet__c(Start_Date__c = Date.newInStance(2017, 11, 20),
                                          Status__c = 'New');
        insert ts;
        Worklog__c wl = new Worklog__c(Start_Time__c = Datetime.newInstance(2017, 11, 21, 11, 30, 0),
                                      End_Time__c = Datetime.newInstance(2017, 11, 21, 13, 30, 0),
                                      Description__c = 'Testing',
                                      Status__c = 'New',
                                      Timesheet__c = ts.id,
                                      Project__c = proj.id );
        insert wl;
        
        List<Worklog__c> proposedWorklogs = new List<Worklog__c>();
        
        Worklog__c insideOverlap = new Worklog__c(Start_Time__c = Datetime.newInstance(2017, 11, 21, 11, 40, 0),
                                      	End_Time__c = Datetime.newInstance(2017, 11, 21, 13, 20, 0),
                                      	Description__c = 'Testing',
                                      	Status__c = 'New',
                                      	Timesheet__c = ts.id,
                                      	Project__c = proj.id );
        proposedWorklogs.add(insideOverlap);
        Worklog__c leftOverlap = new Worklog__c(Start_Time__c = Datetime.newInstance(2017, 11, 21, 11, 20, 0),
                                      End_Time__c = Datetime.newInstance(2017, 11, 21, 11, 40, 0),
                                      Description__c = 'Testing',
                                      Status__c = 'New',
                                      Timesheet__c = ts.id,
                                      Project__c = proj.id );
        proposedWorklogs.add(leftOverlap);
        Worklog__c rightOverlap = new Worklog__c(Start_Time__c = Datetime.newInstance(2017, 11, 21, 13, 20, 0),
                                      End_Time__c = Datetime.newInstance(2017, 11, 21, 13, 40, 0),
                                      Description__c = 'Testing',
                                      Status__c = 'New',
                                      Timesheet__c = ts.id,
                                      Project__c = proj.id );
        proposedWorklogs.add(rightOverlap);
        Worklog__c completeOverlap = new Worklog__c(Start_Time__c = Datetime.newInstance(2017, 11, 21, 11, 20, 0),
                                      End_Time__c = Datetime.newInstance(2017, 11, 21, 13, 40, 0),
                                      Description__c = 'Testing',
                                      Status__c = 'New',
                                      Timesheet__c = ts.id,
                                      Project__c = proj.id );
        proposedWorklogs.add(completeOverlap);
        Worklog__c noOverlap = new Worklog__c(Start_Time__c = Datetime.newInstance(2017, 11, 21, 13, 40, 0),
                                      End_Time__c = Datetime.newInstance(2017, 11, 21, 15, 40, 0),
                                      Description__c = 'Testing',
                                      Status__c = 'New',
                                      Timesheet__c = ts.id,
                                      Project__c = proj.id );
        proposedWorklogs.add(noOverlap);
        
        List<Database.SaveResult> results = Database.insert(proposedWorklogs, false);
        
        for(Integer i = 0 ; i < 4 ; i++){
            System.assert(!results.get(i).isSuccess());
        }
        System.assert(results.get(4).isSuccess());
        
        
    }
    
    @isTest
    public static void editSubmittedWorklogTest(){
        
        Account acct = new Account(Name = 'Test Account');
        insert acct;
        
        Project__c proj0 = new Project__c(Name = 'Test Project 1',
                                        Description__c = 'Test Project Description',
                                        Account__c = acct.Id);
        insert proj0;
        
        Project__c proj1 = new Project__c(Name = 'Test Project 2',
                                        Description__c = 'Test Project Description',
                                        Account__c = acct.Id);
        insert proj1;
        
        Timesheet__c ts0 = new Timesheet__c(Start_Date__c = Date.newInStance(2017, 11, 20),
                                          Status__c = 'New');
        insert ts0;
        
        Timesheet__c ts1 = new Timesheet__c(Start_Date__c = Date.newInStance(2017, 11, 27),
                                          Status__c = 'New');
        insert ts1;
        
        List<Worklog__c> wlList = new List<Worklog__c>();
        Worklog__c wl = new Worklog__c(Start_Time__c = Datetime.newInstance(2017, 11, 21, 11, 30, 0),
                                      End_Time__c = Datetime.newInstance(2017, 11, 21, 13, 30, 0),
                                      Description__c = 'Testing',
                                      Status__c = 'Submitted',
                                      Timesheet__c = ts0.Id,
                                      Project__c = proj0.Id );
        wlList.add(wl);
        insert wlList;
        
       
        
        //wlList.get(0).Start_Time__c = Datetime.newInstance(2017, 11, 21, 11, 31, 0);
        //List<Database.SaveResult> startTimeChangeResult = Database.update(wlList, false);
        //System.assert(!startTimeChangeResult.get(0).isSuccess());
        //System.assertEquals('NO EDIT', startTimeChangeResult.get(0).getErrors().get(0).getMessage());
        
        wlList.get(0).End_Time__c = Datetime.newInstance(2017, 11, 21, 13, 31, 0);
        List<Database.SaveResult> endTimeChangeResult = Database.update(wlList, false);
        System.assert(!endTimeChangeResult.get(0).isSuccess());
        System.assertEquals('Submitted Worklogs Cannot Be Edited', endTimeChangeResult.get(0).getErrors().get(0).getMessage());
        
        
        wlList.get(0).Description__c = 'Change Description';
        List<Database.SaveResult> descriptionChangeResult = Database.update(wlList, false);
        System.assert(!descriptionChangeResult.get(0).isSuccess());
        System.assertEquals('Submitted Worklogs Cannot Be Edited', descriptionChangeResult.get(0).getErrors().get(0).getMessage());
        
        //wlList.get(0).Timesheet__c = ts1.Id;
        //List<Database.SaveResult> timesheetChangeResult = Database.update(wlList, false);
        //System.assert(!timesheetChangeResult.get(0).isSuccess());
        //System.assertEquals('NO EDIT', timesheetChangeResult.get(0).getErrors().get(0).getMessage());
        
        //wlList.get(0).Project__c = proj1.Id;
        //List<Database.SaveResult> projectChangeResult = Database.update(wlList, false);
        //System.assert(!projectChangeResult.get(0).isSuccess());
        //System.assertEquals('NO EDIT', projectChangeResult.get(0).getErrors().get(0).getMessage());
    }
    
    @isTest
    public static void checkOverlapUpdate(){
        
        Account acct = new Account(Name = 'Test Account');
        insert acct;
        
        Project__c proj0 = new Project__c(Name = 'Test Project 1',
                                        Description__c = 'Test Project Description',
                                        Account__c = acct.Id);
        insert proj0;
        
        
        
        Timesheet__c ts0 = new Timesheet__c(Start_Date__c = Date.newInStance(2017, 11, 20),
                                          Status__c = 'New');
        insert ts0;
        
        
        List<Worklog__c> wlList = new List<Worklog__c>();
        Worklog__c A = new Worklog__c(Start_Time__c = Datetime.newInstance(2017, 11, 21, 13, 00, 0),
                                      End_Time__c = Datetime.newInstance(2017, 11, 21, 14, 00, 0),
                                      Description__c = 'Testing',
                                      Status__c = 'New',
                                      Timesheet__c = ts0.Id,
                                      Project__c = proj0.Id );
        
        Worklog__c B = new Worklog__c(Start_Time__c = Datetime.newInstance(2017, 11, 21, 15, 00, 0),
                                      End_Time__c = Datetime.newInstance(2017, 11, 21, 16, 00, 0),
                                      Description__c = 'Testing',
                                      Status__c = 'New',
                                      Timesheet__c = ts0.Id,
                                      Project__c = proj0.Id );
        
        Worklog__c C = new Worklog__c(Start_Time__c = Datetime.newInstance(2017, 11, 21, 17, 00, 0),
                                      End_Time__c = Datetime.newInstance(2017, 11, 21, 18, 00, 0),
                                      Description__c = 'Testing',
                                      Status__c = 'New',
                                      Timesheet__c = ts0.Id,
                                      Project__c = proj0.Id );
        wlList.add(A);
        wlList.add(B);
        wlList.add(C);
        insert wlList;
        
        wlList.get(0).End_Time__c = Datetime.newInstance(2017, 11, 21, 13, 50, 00);
        wlList.get(1).End_Time__c = Datetime.newInstance(2017, 11, 21, 17, 10, 00);
        
        List<Database.SaveResult> result = Database.update(wlList, false);
        System.assert(result.get(0).isSuccess());
        System.assert(!result.get(1).isSuccess());
        
        
    }
    
    @isTest
    public static void submittedWorklogsCannotBeDeletedTest(){
        
        Account acct = new Account(Name = 'Test Account');
        insert acct;
        
        Project__c proj0 = new Project__c(Name = 'Test Project 1',
                                        Description__c = 'Test Project Description',
                                        Account__c = acct.Id);
        insert proj0;
        
        
        
        Timesheet__c ts0 = new Timesheet__c(Start_Date__c = Date.newInStance(2017, 11, 20),
                                          Status__c = 'New');
        insert ts0;
        
        
        List<Worklog__c> wlList = new List<Worklog__c>();
        Worklog__c newWorklog = new Worklog__c(Start_Time__c = Datetime.newInstance(2017, 11, 21, 13, 00, 0),
                                      End_Time__c = Datetime.newInstance(2017, 11, 21, 14, 00, 0),
                                      Description__c = 'Testing',
                                      Status__c = 'New',
                                      Timesheet__c = ts0.Id,
                                      Project__c = proj0.Id );
        
        Worklog__c submittedWorklog = new Worklog__c(Start_Time__c = Datetime.newInstance(2017, 11, 21, 15, 00, 0),
                                      End_Time__c = Datetime.newInstance(2017, 11, 21, 16, 00, 0),
                                      Description__c = 'Testing',
                                      Status__c = 'Submitted',
                                      Timesheet__c = ts0.Id,
                                      Project__c = proj0.Id );
        
        
        wlList.add(newWorklog);
        wlList.add(submittedWorklog);
        
        insert wlList;
        
        List<Database.DeleteResult> result = Database.delete(wlList, false);
        System.assert(result.get(0).isSuccess());
        System.assert(!result.get(1).isSuccess());
    }
}