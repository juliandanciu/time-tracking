public class ApproverController {

    //our collection of the class/wrapper objects cWorklog
    
    public List<cWorklog> worklogList {get; set;}
    
    public List<cWorklog> getWorklogs(){
        if(worklogList == NULL ){
            worklogList = new List<cWorklog>();
            //get the user id 
           	Id runningId = UserInfo.getUserId();
            List<Approver__c> approver = [SELECT Id, Project__c, User__c FROM Approver__c WHERE User__c = :runningId ];
            Set<Id> projIds = new Set<Id>();
            for(Approver__c aprov : approver){
                projIds.add(aprov.Project__c);
            }
            for(Worklog__c wl : [SELECT Name, Timesheet__r.User__r.Name, Project__r.Name, 
                                 		Start_Time__c, End_Time__c,Description__c,Status__c 
                                 FROM Worklog__c 
                                 WHERE Status__c = 'Submitted' AND Project__c IN :projIds
                                ORDER BY Name]){
            	
               worklogList.add(new cWorklog(wl));
            }
        }
        return worklogList; 
        
    }
    
    
    
    public class cWorklog {
        public Worklog__c worklog {get; set;}
        public Boolean isSelected {get; set;}
        
        public cWorklog(Worklog__c wl){
            worklog = wl;
            isSelected = false;
        }
    }
    
    public void rejectSelected() {        
        system.debug('You clicked reject Selected'); 
        //find which worklogs were are selected
        List<Worklog__c> worklogsToReject = new List<Worklog__c>();
        for(cWorklog cwl : getWorklogs()){
            if(cwl.isSelected){
                cwl.worklog.Status__c = 'Rejected';
                worklogsToReject.add(cwl.worklog);
            }
        }
        
        //dml operation 
        
        update worklogsToReject;
        worklogList = NULL;
        ApexPages.Message em = new ApexPages.Message(ApexPages.severity.CONFIRM, 'Success Reject!');
            
        ApexPages.addMessage(em);
        
        
    }
    
    public void approveSelected() {
        system.debug('You clicked approve Selected');
        List<Worklog__c> worklogsToApprove = new List<Worklog__c>();
        for(cWorklog cwl : getWorklogs()){
            if(cwl.isSelected){
                cwl.worklog.Status__c = 'Approved';
                worklogsToApprove.add(cwl.worklog);
            }
        }
        
        //dml operation
        update worklogsToApprove;
        
        ApexPages.Message em = new ApexPages.Message(ApexPages.severity.CONFIRM, 'Success Approve!');
            
        ApexPages.addMessage(em);
        
        worklogList = NULL; 
        
       
    }
    
    public void selectAll() {
        system.debug('You clicked Select All ');
        
        for(cWorklog cwl : getWorklogs()){
            cwl.isSelected = true;
        }
       
        
       
    }
    
    
    

      
}