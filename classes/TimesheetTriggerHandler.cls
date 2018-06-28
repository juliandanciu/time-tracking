public class TimesheetTriggerHandler {
	
    public static void enforceMondayStartDate(List<Timesheet__c> triggerNew){
        for(Timesheet__c timesheet : triggerNew){
        	String day = WeekDayCalculator.calculateWeekDay(timesheet.Start_Date__c);
        	if (day != 'Monday'){
            	timesheet.addError('Start Day must be a Monday!');
        	}
    	}
        
    }
    
    public static void enforceNoEditIfSubmitted(List<Timesheet__c> triggerNew, Map<Id, Timesheet__c> triggerOldMap, Map<Id, Timesheet__c> triggerNewMap){
        
        //a  submitted timesheet s hould not be available for editing except
    	//to change its status and it should not be avaiable for deletion 
    	//
    	Map<Id,Timesheet__c> beforeMap = triggerOldMap;
    	Map<Id, Timesheet__c> afterMap  = triggerNewMap;
    	
            
    	for(Timesheet__c ts : triggerNew){
        	Id i = ts.id;
        	if(ts.Status__c == 'Submitted'){
            
            	if(beforeMap.get(i).Start_Date__c != afterMap.get(i).Start_Date__c){
            		ts.addError('You cannot edit this field while SUBMITTED!');
        		} else if (beforeMap.get(i).User__c != afterMap.get(i).User__c) {
            		ts.addError('You cannot edit this field while SUBMITTED!');
        		} 
        
            } else if(ts.Status__c == 'Approved') {
                if(beforeMap.get(i).Start_Date__c != afterMap.get(i).Start_Date__c){
            		ts.addError('You cannot edit this field while Approved!');
        		} else if (beforeMap.get(i).User__c != afterMap.get(i).User__c) {
            		ts.addError('You cannot edit this field while Approved!');
        		} 
            }
    	}
        
    }
    
    public static void statusCorresponds(List<Timesheet__c> triggerNew, Map<Id, Timesheet__c> triggerOldMap){
        //this should fire when a timesheet has been updated from 
    	//new to submitted
    	System.debug('STAR WARS 3');
    	List<Worklog__c> childWorkLogs = [SELECT Id, Status__c, Timesheet__c FROM Worklog__c WHERE Timesheet__c IN :triggerNew];
    	System.debug(triggerNew);
        System.debug(childWorkLogs);
    	for(Timesheet__c ts : triggerNew){
        	Id i = ts.Id; 
        	if(ts.Status__c == 'Submitted' && triggerOldMap.get(i).Status__c == 'New'){
            	for(Worklog__c wl : childWorkLogs){
                	if(wl.Timesheet__c == ts.Id){
                    	wl.Status__c = 'Submitted';
                	}
            	}
        	} else if (ts.Status__c == 'New' && (triggerOldMap.get(i).Status__c == 'Submitted' || triggerOldMap.get(i).Status__c == 'Approved')){
            	for(Worklog__c wl : childWorkLogs){
                	if(wl.Timesheet__c == ts.Id){
                    	wl.Status__c = 'New';
                	}
            	}
        	} else if (ts.Status__c == 'Submitted' && triggerOldMap.get(i).Status__c == 'Needs Attention'){
            	System.debug('Star Wars 3.25');
                for(Worklog__c wl : childWorkLogs){
                	if(wl.Timesheet__c == ts.Id){
                        System.debug(wl);
                        if(wl.Status__c == 'New' || wl.Status__c == 'Rejected'){
                            wl.Status__c = 'Submitted';
                        }
                            
                	}
            	}
        	}
    	}
    	update childWorkLogs; 
        System.debug('Star Wars 3.5');
    
        
    }
    
    public static void submittedTimesheetsCannotBeDeleted(List<Timesheet__c> triggerOld){
        
        for(Timesheet__c ts : triggerOld){
            if (ts.Status__c == 'Submitted'){
                ts.addError('Submitted Timesheets Cannot Be Deleted');
            }
            
        }
        
    }
    
    public static void cannotChangeIfParent(List<Timesheet__c> triggerNew, Map<Id, Timesheet__c> triggerOldMap, Map<Id, Timesheet__c> triggerNewMap){
        
        List<Worklog__c> allWorklogs = [SELECT Id, Timesheet__c FROM Worklog__c];
        List<Timesheet__c> parentTimesheets = new List<Timesheet__c>();
        
        for(Timesheet__c ts : triggerNew){
            for(Worklog__c wl : allWorklogs){
                if(wl.Timesheet__c == ts.id){
                    parentTimesheets.add(ts);
                }
            }
            
        }
        
        for(Timesheet__c ts : parentTimesheets){
            if(triggerOldMap.get(ts.id).Start_Date__c != triggerNewMap.get(ts.id).Start_Date__c){
                ts.addError('Cannot change the start date when there are child worklogs!');
            }
        }
       
    
    }    
        
        
        
    
    
}