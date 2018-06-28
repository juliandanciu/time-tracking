public class WorklogTriggerHandler {
	
    public static void checkOverlapInsertREDO(List<Worklog__c> triggerNew){
        System.debug('CHECK OVERLAP REDO');
        
        Set<Id> relevantTimesheetIds = new Set<Id>();
        for(Worklog__c w : triggerNew){
            relevantTimesheetIds.add(w.Timesheet__c);
        }
                
        List<Timesheet__c> parentTimesheets = [SELECT Id, (SELECT Start_Time__c, End_Time__c FROM Worklogs__r) FROM Timesheet__c WHERE Id IN :relevantTimesheetIds];
        
        Map<Id, List<Worklog__c>> tsId_childWorklogs = new Map<Id, List<Worklog__c>>();

        for(Timesheet__c parTS : parentTimesheets){
            tsId_childWorklogs.put(parTS.id, parTS.Worklogs__r);
        }
        
        
        for(Worklog__c w : triggerNew){
            for(Worklog__c wl : tsId_childWorklogs.get(w.Timesheet__c)){
                if(w.Start_Time__c < wl.End_Time__c && w.End_Time__c > wl.Start_Time__c){
                    w.addError('Overlap');
                } else {
                    tsId_childWorklogs.get(w.Timesheet__c).add(w);
                } 
            }  
        }
            
            
        
    }
    
    
    public static void checkOverlapInsert(List<Worklog__c> triggerNew){
        System.debug('CHECK OVERLAP');
        List<Worklog__c> approvedTriggerWorklogs = new List<Worklog__c>();
    	
    	System.debug(approvedTriggerWorklogs);
    	System.debug(trigger.new);
    	
        
        
        List<Worklog__c> allWL = [SELECT Id, Timesheet__c FROM Worklog__c];
        
        
        
    	for(Worklog__c worklog : triggerNew){
        	//get the parent time sheet for the worklog in question
        	
            Boolean isParentAlready = false; 
            //HOW TO GET RID OF THIS QUERY IN THE FOR LOOP?????
            Timesheet__c parTS = [SELECT ID FROM Timesheet__c WHERE ID = :worklog.Timesheet__c];
            for(Worklog__c WL : allWL){
                if(WL.Timesheet__c == parTS.id ){
                    isParentAlready = true;
                }
            }
        	System.debug(isParentAlready);
            System.debug('TEST RUN 2');
            
            if (isParentAlready == true){
                Timesheet__c parentTimeSheet = [SELECT Id, (SELECT Start_Time__c, End_Time__c FROM Worklogs__r) FROM Timesheet__c WHERE Id = :worklog.Timesheet__c];
        		System.debug(parentTimeSheet);
        		List<Worklog__c> currentWorklogs = parentTimeSheet.Worklogs__r;
        		System.debug(currentWorklogs);
        
        		List<Worklog__c> allWorkLogs = new List<Worklog__c>(currentWorklogs);
        		allWorkLogs.addAll(approvedTriggerWorklogs);
        		System.debug(allWorkLogs);
        
        		for(Worklog__c wl : allWorkLogs){
            		System.debug(worklog.Start_Time__c);
            		System.debug(wl.End_Time__c);
            		System.debug(worklog.End_Time__c);
            		System.debug(wl.Start_Time__c);
            		if(worklog.Start_Time__c < wl.End_Time__c && worklog.End_Time__c > wl.Start_Time__c){
                		//AuraHandledException e = new AuraHandledException('Overlap');
                        //e.setMessage('Overlap');
                        worklog.addError('Overlap');
                        //system.debug(e);
                        //throw e;
                    } else{
                        approvedTriggerWorklogs.add(worklog); //erase this is its broken
                    } 
        		}
            }
            
        	
    	}
    
    
    } 
    
    public static void editSubmittedWorklog(List<Worklog__c> triggerNew, Map<Id,Worklog__c> triggerOldMap, Map<Id, Worklog__c> triggerNewMap){
        
        
    
    	for(Worklog__c wl : triggerNew){
        	Id i = wl.id;
        	if(wl.Status__c == 'Submitted'){
            	if(   (triggerOldMap.get(i).Start_Time__c != triggerNewMap.get(i).Start_Time__c) || (triggerOldMap.get(i).End_Time__c != triggerNewMap.get(i).End_Time__c) || (triggerOldMap.get(i).Description__c != triggerNewMap.get(i).Description__c) ||(triggerOldMap.get(i).Project__c != triggerNewMap.get(i).Project__c)
                  ){
            		wl.addError('Submitted Worklogs Cannot Be Edited');
        		} 
        
            } else if (wl.Status__c == 'Approved'){
                if(   (triggerOldMap.get(i).Start_Time__c != triggerNewMap.get(i).Start_Time__c) || (triggerOldMap.get(i).End_Time__c != triggerNewMap.get(i).End_Time__c) || (triggerOldMap.get(i).Description__c != triggerNewMap.get(i).Description__c) ||(triggerOldMap.get(i).Project__c != triggerNewMap.get(i).Project__c)
                  ){
            		wl.addError('Approved Worklogs Cannot Be Edited');
        		} 
            }
        
    	}
    
        
        
    }
    
    public static void submittedWorklogsCannotBeDeleted(List<Worklog__c> triggerOld){
        
        
        for(Worklog__c wl : triggerOld){
            if(wl.Status__c == 'Submitted' ){
                wl.addError('Submitted Worklogs Cannot Be Deleted!');
            } else if (wl.Status__c == 'Approved'){
                wl.addError('Approved Worklogs Cannot Be Deleted!');
            }
        }
    }
    
    public static void checkOverlapUpdate(List<Worklog__c> triggerNew, Map<Id, Worklog__c> triggerOldMap, Map<Id, Worklog__c> triggerNewMap){
        
        Set<Worklog__c> approvedWLs = new Set<Worklog__c>();
        Set<Worklog__c> changedWLs = new Set<Worklog__c>();
        Set<Worklog__c> changedWLsOLD = new Set<Worklog__c>();
        
    	
    	for(Worklog__c wl : triggerNew){
            if((triggerOldMap.get(wl.Id).Start_Time__c != triggerNewMap.get(wl.Id).Start_Time__c) || (triggerOldMap.get(wl.Id).End_Time__c != triggerNewMap.get(wl.Id).End_Time__c)){
                changedWLs.add(wl);
                changedWLsOLD.add(triggerOldMap.get(wl.id));
                
            }
        }
        
     
        
       
    	for(Worklog__c cWL : changedWLS){
        	//get the parent time sheet for the worklog in question
            
        	Timesheet__c parentTS = [SELECT Id, (SELECT Start_Time__c, End_Time__c FROM Worklogs__r) FROM Timesheet__c WHERE Id = :cWL.Timesheet__c];
 
            List<Worklog__c> transfer = parentTS.Worklogs__r;
            Set<Worklog__c> landscapeWLs = new Set<Worklog__c>(transfer);
            
            Set<Worklog__c> checkAgainst = new Set<Worklog__c>();
            checkAgainst.addAll(landscapeWLs);
            
            
            
            
            
            //need to make sure this actually works
            Set<Worklog__c> actuallyRemove = new Set<Worklog__c>();
            //checkAgainst.removeAll(changedWLsOLD);
            for(Worklog__c landscape : checkAgainst){
                for(Worklog__c changed : changedWLsOLD){
                    if(changed.id == landscape.id){
                        actuallyRemove.add(landscape);
                    }
                }
            }
            checkAgainst.removeAll(actuallyRemove);
            
            checkAgainst.addAll(approvedWLs);
           	System.debug('After you add the approved!');
            System.debug(checkAgainst);
             
           	
      		Boolean overlap = false;
            for(Worklog__c wl : checkAgainst){            
            	if(cWL.Start_Time__c < wl.End_Time__c && cWL.End_Time__c > wl.Start_Time__c){
               		//AuraHandledException e = new AuraHandledException('Overlap');
                    //e.setMessage('Overlap');
                    //system.debug(e);
                    //throw e;
                    cWL.addError('Overlap');
                    overlap = true;
                }
                
                
            
                
        	}
            
            if(overlap == false){
                approvedWLs.add(cWL);
            }
            
            
    	}
    
    
    }
    
   /* public static void checkOverlapUpdateREDO(List<Worklog__c> triggerNew, Map<Id, Worklog__c> triggerOldMap, Map<Id, Worklog__c> triggerNewMap){
        
        Set<Worklog__c> approvedWLs = new Set<Worklog__c>();
        Set<Worklog__c> changedWLs = new Set<Worklog__c>();
        Set<Worklog__c> changedWLsOLD = new Set<Worklog__c>();
        
    	
    	for(Worklog__c wl : triggerNew){
            if((triggerOldMap.get(wl.Id).Start_Time__c != triggerNewMap.get(wl.Id).Start_Time__c) || (triggerOldMap.get(wl.Id).End_Time__c != triggerNewMap.get(wl.Id).End_Time__c)){
                changedWLs.add(wl);
                changedWLsOLD.add(triggerOldMap.get(wl.id));
                
            }
        }
        
        Set<Id> parTSIds = new Set<Id>();
        for(Worklog__c cWL : changedWLS){
            parTSIds.add(cWl.Id);
        }
        
     	List<Timesheet__c> parTSs = [SELECT Id, (SELECT Start_Time__c, End_Time__c FROM Worklogs__r) FROM Timesheet__c WHERE Id IN :parTSIds];
        
       
    	for(Worklog__c cWL : changedWLS){
        	//get the parent time sheet for the worklog in question
            
        	Timesheet__c parentTS; 
            for(Timesheet__c timesheetd : parTSs){
                if(timesheetd.Id == cWL.Timesheet__c){
                    parentTS = timesheetd;
                    return;
                }
            }
 
            List<Worklog__c> transfer = parentTS.Worklogs__r;
            Set<Worklog__c> landscapeWLs = new Set<Worklog__c>(transfer);
            
            Set<Worklog__c> checkAgainst = new Set<Worklog__c>();
            checkAgainst.addAll(landscapeWLs);
            
            
            
            
            
            //need to make sure this actually works
            Set<Worklog__c> actuallyRemove = new Set<Worklog__c>();
            //checkAgainst.removeAll(changedWLsOLD);
            for(Worklog__c landscape : checkAgainst){
                for(Worklog__c changed : changedWLsOLD){
                    if(changed.id == landscape.id){
                        actuallyRemove.add(landscape);
                    }
                }
            }
            checkAgainst.removeAll(actuallyRemove);
            
            checkAgainst.addAll(approvedWLs);
           	System.debug('After you add the approved!');
            System.debug(checkAgainst);
             
           	
      		Boolean overlap = false;
            for(Worklog__c wl : checkAgainst){            
            	if(cWL.Start_Time__c < wl.End_Time__c && cWL.End_Time__c > wl.Start_Time__c){
               		//AuraHandledException e = new AuraHandledException('Overlap');
                    //e.setMessage('Overlap');
                    //system.debug(e);
                    //throw e;
                    cWL.addError('Overlap');
                    overlap = true;
                }
                
                
            
                
        	}
            
            if(overlap == false){
                approvedWLs.add(cWL);
            }
            
            
    	}
    
    
    } */
    /*
     * Requirements: Each time a worklog's status is updated, its parent timesheet status
     * shoduld be updated accordingly. Refer to the timesheet status description for direction.
     */
    public static void editParentTimesheetAccordingly(List<Worklog__c> triggerNew, Map<Id, Worklog__c> triggerOldMap, Map<Id, Worklog__c> triggerNewMap){
        //System.debug('trigger activated');
        Set<Id> parTimesheetIds = new Set<Id>();
        List<Worklog__c> statusChangedWorklogs = new List<Worklog__c>();
        //check if the status has been updated.
        for(Worklog__c wl : triggerNew){
            if(triggerOldMap.get(wl.Id).Status__c != wl.Status__c){
                parTimesheetIds.add(wl.Timesheet__c);
                statusChangedWorklogs.add(wl);
            }
        }
        //System.debug('trigger activated 2');
        List<Timesheet__c> parTSs = [SELECT Id, Status__c, (SELECT Status__c FROM Worklogs__r) FROM Timesheet__c WHERE Id IN :parTimesheetIds];
        Map<Id, Timesheet__c> timesheetId_timesheetSObject = new Map<Id, Timesheet__c>();
        
        for(Timesheet__c ts : parTSs){
            timesheetId_timesheetSObject.put(ts.Id, ts);
        }
        //System.debug('trigger activated 3');
        for(Timesheet__c ts : parTSs){
            //System.debug('trigger activated 4');
            List<Worklog__c> childWorklogs = ts.Worklogs__r;
            Integer size = childWorklogs.size();
            Integer newWL = 0;
            Integer subWL = 0;
            Integer rejWL = 0;
            Integer appWL = 0;
            for(Worklog__c wl : childWorklogs){
                System.debug('trigger activated 5');
                if(wl.Status__c == 'Rejected'){
                    rejWL++;
                } else if (wl.Status__c == 'Approved'){
                    appWL++;
                } else if (wl.Status__c == 'New'){
                    newWL++;
                } else if (wl.Status__c == 'Submitted'){
                    subWL++;
                }
            }
            
            if(appWL == size){
                ts.Status__c = 'Approved';
            } else if (rejWL > 0){
                ts.Status__c = 'Needs Attention';
            } else if (appWL > 0){
                ts.Status__c = 'Under Review';
            } else if (subWL == size){
                ts.Status__c = 'Submitted';
            }
            
            update ts;
        }
        
        
    }
    
    public static void editParentTimesheetAccordinglyDelete(List<Worklog__c> triggerOld, Map<Id, Worklog__c> triggerOldMap, Map<Id, Worklog__c> triggerNewMap){
        //System.debug('trigger activated');
        Set<Id> parTimesheetIds = new Set<Id>();
        
        //check if the status has been updated.
        for(Worklog__c wl : triggerOld){
            parTimesheetIds.add(wl.Timesheet__c);
        }
        //System.debug('trigger activated 2');
        List<Timesheet__c> parTSs = [SELECT Id, Status__c, (SELECT Status__c FROM Worklogs__r) FROM Timesheet__c WHERE Id IN :parTimesheetIds];
        Map<Id, Timesheet__c> timesheetId_timesheetSObject = new Map<Id, Timesheet__c>();
        
        for(Timesheet__c ts : parTSs){
            timesheetId_timesheetSObject.put(ts.Id, ts);
        }
        //System.debug('trigger activated 3');
        for(Timesheet__c ts : parTSs){
            //System.debug('trigger activated 4');
            List<Worklog__c> childWorklogs = ts.Worklogs__r;
            Integer size = childWorklogs.size();
            Integer newWL = 0;
            Integer subWL = 0;
            Integer rejWL = 0;
            Integer appWL = 0;
            for(Worklog__c wl : childWorklogs){
                System.debug('trigger activated 5');
                if(wl.Status__c == 'Rejected'){
                    rejWL++;
                } else if (wl.Status__c == 'Approved'){
                    appWL++;
                } else if (wl.Status__c == 'New'){
                    newWL++;
                } else if (wl.Status__c == 'Submitted'){
                    subWL++;
                }
            }
            
            if(appWL == size){
                ts.Status__c = 'Approved';
            } else if (rejWL > 0){
                ts.Status__c = 'Needs Attention';
            } else if (appWL > 0){
                ts.Status__c = 'Under Review';
            } else if (subWL == size){
                ts.Status__c = 'Submitted';
            }
            
            update ts;
        }
        
        
    }
    
    public static void editParentTimesheetAccordinglyCreate(List<Worklog__c> triggerNew, Map<Id, Worklog__c> triggerOldMap, Map<Id, Worklog__c> triggerNewMap){
        //System.debug('trigger activated');
        Set<Id> parTimesheetIds = new Set<Id>();
        
        //check if the status has been updated.
        for(Worklog__c wl : triggerNew){
            parTimesheetIds.add(wl.Timesheet__c); 
        }
        
        //System.debug('trigger activated 2');
        List<Timesheet__c> parTSs = [SELECT Id, Status__c, (SELECT Status__c FROM Worklogs__r) FROM Timesheet__c WHERE Id IN :parTimesheetIds];
        Map<Id, Timesheet__c> timesheetId_timesheetSObject = new Map<Id, Timesheet__c>();
        
        for(Timesheet__c ts : parTSs){
            timesheetId_timesheetSObject.put(ts.Id, ts);
        }
        //System.debug('trigger activated 3');
        for(Timesheet__c ts : parTSs){
            //System.debug('trigger activated 4');
            List<Worklog__c> childWorklogs = ts.Worklogs__r;
            Integer size = childWorklogs.size();
            Integer newWL = 0;
            Integer subWL = 0;
            Integer rejWL = 0;
            Integer appWL = 0;
            for(Worklog__c wl : childWorklogs){
                System.debug('trigger activated 5');
                if(wl.Status__c == 'Rejected'){
                    rejWL++;
                } else if (wl.Status__c == 'Approved'){
                    appWL++;
                } else if (wl.Status__c == 'New'){
                    newWL++;
                } else if (wl.Status__c == 'Submitted'){
                    subWL++;
                }
            }
            
            if(appWL == size){
                ts.Status__c = 'Approved';
            } else if (rejWL > 0){
                ts.Status__c = 'Needs Attention';
            } else if (appWL > 0){
                ts.Status__c = 'Under Review';
            } else if (subWL == size){
                ts.Status__c = 'Submitted';
            }
            
            update ts;
        }
        
        
    }
    
        
       
}