@isTest
public class TestCreateTasksAndScheduler {
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
        String jobId = System.schedule('myJobTestJobName', cronExpr, new CreateTasksScheduler());
        Test.stopTest();

        List<AsyncApexJob> jobsScheduled = [
            SELECT Id, ApexClassID, ApexClass.Name, Status, JobType
            FROM AsyncApexJob
            WHERE JobType = 'ScheduledApex'
        ];
        System.assertEquals(1, jobsScheduled.size(), 'expecting one scheduled job');
        System.assertEquals(
            'CreateTasksScheduler',
            jobsScheduled[0].ApexClass.Name,
            'expecting specific scheduled job'
        );

        // check apex batch is in the job list
        List<AsyncApexJob> jobsApexBatch = [
            SELECT Id, ApexClassID, ApexClass.Name, Status, JobType
            FROM AsyncApexJob
            WHERE JobType = 'BatchApex'
        ];
        System.assertEquals(1, jobsApexBatch.size(), 'expecting one apex batch job');
        System.assertEquals(
            'CreateTasks',
            jobsApexBatch[0].ApexClass.Name,
            'expecting specific batch job'
        );
    }
}
