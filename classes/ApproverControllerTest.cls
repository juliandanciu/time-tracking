@isTest
public class ApproverControllerTest {
	
    @isTest
    static void getWorklogsTest_wrapper_checkreject(){
        //test setup
        ControllerTestFactory.initApproverTest();
        
        //instantiate controller class
        ApproverController myAC = new ApproverController();
        
        //wrap the existing worklogs
        List<ApproverController.cWorklog> wrappedWorklogs = myAC.getWorklogs();
        
        //select the checkbox attribut
        myAC.selectAll();
        
        //check if checkbox attribute was really selected
        for(ApproverController.cWorklog cWL : wrappedWorklogs){
            System.assertEquals(true, cWl.isSelected);
        }
        
        //reject all the worklogs
        myAC.rejectSelected();
        
        //test the rejection 
        for(ApproverController.cWorklog cWL : wrappedWorklogs){
            System.assertEquals('Rejected', cWl.worklog.Status__c);
        }
        
        
    }
    
    @isTest
    static void getWorklogsTest_wrapper_checkapprove(){
        //test setup
        ControllerTestFactory.initApproverTest();
        
        //instantiate controller class
        ApproverController myAC = new ApproverController();
        
        //wrap the existing worklogs
        List<ApproverController.cWorklog> wrappedWorklogs = myAC.getWorklogs();
        
        //select the checkbox attribut
        myAC.selectAll();
        
        //check if checkbox attribute was really selected
        for(ApproverController.cWorklog cWL : wrappedWorklogs){
            System.assertEquals(true, cWl.isSelected);
        }
        
        //reject all the worklogs
        myAC.approveSelected();
        
        //test the rejection 
        for(ApproverController.cWorklog cWL : wrappedWorklogs){
            System.assertEquals('Approved', cWl.worklog.Status__c);
        }
        
        
    }
}