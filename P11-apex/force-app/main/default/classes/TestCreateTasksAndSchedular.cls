@isTest
public class TestCreateTasksAndSchedular {
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
    @isTest
    static void testScheduler() {
        // CRON expression: 22 PM every first Monady of the Month.
        String cronExpr = '0 0 22 ? * 2#1';

        Test.startTest();
        CreateTasksSchedular abs = new CreateTasksSchedular();
        String jobId = System.schedule('myJobTestJobName', cronExpr, abs);
        Test.stopTest();
        System.assertEquals(size + 200, [SELECT COUNT() FROM Task]);

        Task b = [SELECT whatId FROM Task WHERE Subject = 'Call' LIMIT 1];
        Account Acc = [SELECT name FROM Account WHERE id = :b.whatId];

        System.assertEquals(true, Acc.name.contains('Account with no task '));
    }
}
