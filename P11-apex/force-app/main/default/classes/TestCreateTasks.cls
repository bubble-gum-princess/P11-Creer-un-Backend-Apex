@isTest
public class TestCreateTasks {
    static integer size = 200;

    @TestSetup
    public static void LoadData() {
        TestDataFactory.insertAccountsAndTasks(size);
    }

    @isTest
    public static void test() {
        System.assertEquals(size, [SELECT COUNT() FROM Task]);

        Test.startTest();
        CreateTasks ta = new CreateTasks();
        Id batchId = Database.executeBatch(ta);
        Test.stopTest();

        System.assertEquals(size + 200, [SELECT COUNT() FROM Task]);

        Task a = [SELECT whatId FROM Task WHERE Subject = 'Call' LIMIT 1];
        Account acc = [SELECT name FROM Account WHERE id = :a.whatId];

        System.assertEquals(true, acc.name.contains('Account with no task '));
    }
}
