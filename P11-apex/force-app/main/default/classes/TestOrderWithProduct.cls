@isTest
public class TestOrderWithProduct {
    @TestSetup
    public static void LoadData() {

        Account acc1 = new Account(Name = 'Test Account 1',active__c = 'true');
        Account acc2 = new Account(Name = 'Test Account 2');
        
        List<Account> listAccounts = new List<Account>();
        listAccounts.add(acc1);
        listAccounts.add(acc2);
        insert listAccounts;


        Product2 pd1 = new Product2(Name = 'Versace', Family = 'Parfume');
        Insert pd1;
         
        Id pricebookId = Test.getStandardPricebookId();
        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = pd1.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe;

        Order o1 = new Order( Name='delete', AccountId = acc1.Id, Pricebook2Id = pricebookId, Status='Draft',  EffectiveDate=System.today());
        insert o1;
        Order o2 = new Order(Name='nodelete', AccountId = acc2.Id, Pricebook2Id = pricebookId, Status='Draft',  EffectiveDate=System.today());
        insert o2;

        OrderItem oi1 = new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe.Id, UnitPrice = 150, Quantity=1);
        insert oi1;
         
    }
    @isTest public static void Before_Activate_Status_Order(){
        
        
        Order orderBeforeUpdate = [SELECT Status FROM Order WHERE Name='nodelete' LIMIT 1];
        orderBeforeUpdate.Status= 'Active';
        
        Test.startTest();
         Database.SaveResult RS = Database.update(orderBeforeUpdate, false);
        Test.stopTest();
        
        System.assert(!RS.isSuccess());
        System.assertEquals('Veuillez saisir des produits avant activer ordre',
                             RS.getErrors()[0].getMessage());
        

        
    }
    @isTest public static void After_Delete_Order() {
        Order orderAfterDelete = [SELECT accountId FROM Order WHERE Name='delete' LIMIT 1 ];
        Test.startTest();
        Database.DeleteResult result = Database.delete(orderAfterDelete, false);
        Test.stopTest();
        System.assert(result.isSuccess());
        Account acct= [SELECT name, active__c FROM Account WHERE Id=:orderAfterDelete.AccountId];
        System.assertEquals(acct.name, 'Test Account 1');
        System.assertEquals('false', acct.active__c);
        

    }

}