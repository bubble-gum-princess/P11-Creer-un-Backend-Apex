@isTest
public class TestOrderWithProduct {
    @TestSetup
    static void setup() {
        TestDataFactory.LoadData(100);
    }

    @isTest
    public static void Before_Activate_Status_Order() {
        List<Order> listOrders = [SELECT Status FROM Order WHERE Name LIKE 'nodelete%'];
        for (Order orderBeforeUpdate : listOrders) {
            orderBeforeUpdate.Status = 'Active';
        }

        Test.startTest();
        Database.SaveResult[] listRS = Database.update(listOrders, false);
        Test.stopTest();

        for (Database.SaveResult RS : listRS) {
            System.assert(!RS.isSuccess());
            System.assertEquals(
                'Veuillez saisir des produits avant activer la commande',
                RS.getErrors()[0].getMessage()
            );
        }
    }
    @isTest
    public static void After_Delete_Order() {
        List<Order> listOrders = [SELECT accountId FROM Order WHERE Name LIKE 'delete%'];

        Test.startTest();
        Database.DeleteResult[] listResult = Database.delete(listOrders, false);
        Test.stopTest();

        for (Database.DeleteResult result : listResult) {
            System.assert(result.isSuccess());
        }

        Account acct = [
            SELECT name, active__c
            FROM Account
            WHERE Id = :listOrders.get(0).AccountId
        ];
        System.assertEquals(acct.name, 'Test Account 1');
        System.assertEquals('false', acct.active__c);
    }
}
