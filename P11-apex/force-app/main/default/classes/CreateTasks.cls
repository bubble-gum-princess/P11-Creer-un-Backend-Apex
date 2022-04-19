public class CreateTasks implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext BC){
      List<Task> tasks = [Select whatId from Task where what.type='Account'];
        Set<Id> accountsId = new Set<Id>();
        for(Task t : tasks ){
            accountsId.add(t.whatId);
        }
		system.debug(accountsId);
        /* return Database.getQueryLocator('select id from Account ' 
                                +'where id not in (select accountid from Order) '
                                +'and id not in ('+accountsId+')');
		*/
        return Database.getQueryLocator([select id from Account 
                                         where id not in (select accountid from Order)
                                        	and id not in :accountsId]);
   }

   public void execute(Database.BatchableContext BC, List<Account> scope){
       
       AccountService.createNewTask(scope);
       
     
    }

   public void finish(Database.BatchableContext BC){
   }
    
}