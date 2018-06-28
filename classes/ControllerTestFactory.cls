@isTest
public class ControllerTestFactory {
	
    @isTest
    public static Id initControllerTest(){
        //create account for test
        Account acct = new Account(Name = 'Test Account');
        insert acct;
        
        //creat project for test
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
        
        
        return ts.Id;
        
    }
    
    @isTest
    public static Worklog__c initControllerTestUpdate(){
        //create account for test
        Account acct = new Account(Name = 'Test Account');
        insert acct;
        
        //creat project for test
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
        
        
        return wl;
        
    }
    
    @isTest
    public static Timesheet__c initQueryTimesheetTest(){
        //create account for test
        Account acct = new Account(Name = 'Test Account');
        insert acct;
        
        //creat project for test
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
        
        
        return ts;
        
    }
    
    @isTest
    public static Timesheet__c initSubmitTimesheetTest(){
        //create account for test
        Account acct = new Account(Name = 'Test Account');
        insert acct;
        
        //creat project for test
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
        
        
        return ts;
        
    }
    
    @isTest
    public static List<Id> initDeleteSelectedWorklogsTest(){
        //create account for test
        Account acct = new Account(Name = 'Test Account');
        insert acct;
        
        //creat project for test
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
        
        List<Id> selectedWorklogs = new List<Id>();
        selectedWorklogs.add(wl.Id);
        
        return selectedWorklogs;
        
    }
    
    @isTest
    public static Id initApproverTest(){
        //create account for test
        Account acct = new Account(Name = 'Test Account');
        insert acct;
        
        //creat project for test
        Project__c proj = new Project__c(Name = 'Test Project',
                                        Description__c = 'Test Project Description',
                                        Account__c = acct.Id);
        insert proj;
        
        
        Timesheet__c ts = new Timesheet__c(Start_Date__c = Date.newInStance(2017, 11, 20),
                                          Status__c = 'New');
        insert ts;
        
        
        Worklog__c wl0 = new Worklog__c(Start_Time__c = Datetime.newInstance(2017, 11, 21, 11, 30, 0),
                                      End_Time__c = Datetime.newInstance(2017, 11, 21, 13, 30, 0),
                                      Description__c = 'testing 1',
                                      Status__c = 'New',
                                      Timesheet__c = ts.id,
                                      Project__c = proj.id );
        Worklog__c wl1 = new Worklog__c(Start_Time__c = Datetime.newInstance(2017, 11, 22, 11, 30, 0),
                                      End_Time__c = Datetime.newInstance(2017, 11, 22, 13, 30, 0),
                                      Description__c = 'testing 2',
                                      Status__c = 'New',
                                      Timesheet__c = ts.id,
                                      Project__c = proj.id );
        insert wl0;
        insert wl1;
        
        Approver__c approver = new Approver__c();
        approver.Name = 'Test Approver';
        approver.Project__c = proj.id;
        approver.User__c = UserInfo.getUserId();
        
        insert approver;
        
        ts.Status__c = 'Submitted';
        update ts;
        
        return ts.Id;
        
    }
}