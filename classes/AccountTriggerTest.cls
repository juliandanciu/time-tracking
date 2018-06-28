@isTest
public class AccountTriggerTest {
	
    @isTest
    static void accountDeletionTest(){
        //create accounts and child projects 
        List<Account> testAccounts = new List<Account>();
        Account successAcct = new Account(Name = 'Test Success');
        Account failAcct = new Account(Name = 'Test Fail');
        testAccounts.add(successAcct);
        testAccounts.add(failAcct);
        insert testAccounts;
        
        Project__c testProject = new Project__c(Name = 'Testing Project',
                                               Description__c = 'Testing Project Description',
                                               Account__c = testAccounts.get(0).Id);
        insert testProject;
        
        List<Database.DeleteResult> results = Database.delete(testAccounts , false);
        
        System.assert(!results.get(0).isSuccess());
        System.assert(results.get(1).isSuccess());
        System.assertEquals('Cannot delete account with child projects!', results.get(0).getErrors().get(0).getMessage());
        
        
    }
    
        
}