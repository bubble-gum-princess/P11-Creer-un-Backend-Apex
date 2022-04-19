@isTest
public class TestCreateTasks {
    @TestSetup
    public static void LoadData(){
        
            Account acc1 = new Account(Name = 'Test Account 1');
    		insert acc1;
        	Account acc2 = new Account (Name = 'Test Account 2');
        	insert acc2;
        	Task t1 = new Task (whatId = acc2.Id, Subject = 'Email');
        	insert t1;
    
        }
 @isTest
    public static void test(){
        System.assertEquals(1,[SELECT count() FROM TAsk] );

        Test.startTest();
        CreateTasks ta = new CreateTasks();
        Id batchId = Database.executeBatch(ta);
        Test.stopTest();
        System.assertEquals(2,[SELECT count() FROM TAsk] );

       Task a = [SELECT whatId FROM Task Where Subject = 'Call' LIMIT 1];
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account 1' LIMIT 1];
        System.assertEquals(a.whatId,acc.Id );

    }

}