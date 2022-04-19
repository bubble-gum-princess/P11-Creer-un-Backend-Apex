public class CreateTasks implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext BC) {
        List<Task> tasks = [SELECT whatId FROM Task WHERE what.type = 'Account'];
        Set<Id> accountsId = new Set<Id>();
        for (Task t : tasks) {
            accountsId.add(t.whatId);
        }

        return Database.getQueryLocator(
            [
                SELECT id
                FROM Account
                WHERE id NOT IN (SELECT accountid FROM Order) AND id NOT IN :accountsId
            ]
        );
    }

    public void execute(Database.BatchableContext BC, List<Account> scope) {
        OrderService.createNewTask(scope);
    }

    public void finish(Database.BatchableContext BC) {
    }
}
