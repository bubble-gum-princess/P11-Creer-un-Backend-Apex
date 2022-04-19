@IsTest
public class TestDataFactory {
    public static void LoadData(integer size) {
        Account acc1 = new Account(Name = 'Test Account 1', active__c = 'true');
        Account acc2 = new Account(Name = 'Test Account 2');

        List<Account> listAccounts = new List<Account>();
        listAccounts.add(acc1);
        listAccounts.add(acc2);
        insert listAccounts;

        Product2 pd1 = new Product2(Name = 'Versace', Family = 'Parfume');
        insert pd1;

        Id pricebookId = Test.getStandardPricebookId();
        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = pd1.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        insert pbe;

        List<Order> listOrders = new List<Order>();
        List<OrderItem> listOrderItems = new List<OrderItem>();

        // insert delete orders
        for (integer i = 0; i < size; i++) {
            listOrders.add(
                new Order(
                    Name = 'delete' + i,
                    AccountId = acc1.Id,
                    Pricebook2Id = pricebookId,
                    Status = 'Draft',
                    EffectiveDate = System.today()
                )
            );
        }
        insert listOrders;
        for (Order o : listOrders) {
            listOrderItems.add(
                new OrderItem(
                    OrderId = o.Id,
                    PricebookEntryId = pbe.Id,
                    UnitPrice = 150,
                    Quantity = 1
                )
            );
        }
        insert listOrderItems;

        // insert nodelete orders
        listOrders.clear();
        for (integer i = 0; i < size; i++) {
            listOrders.add(
                new Order(
                    Name = 'nodelete' + i,
                    AccountId = acc2.Id,
                    Pricebook2Id = pricebookId,
                    Status = 'Draft',
                    EffectiveDate = System.today()
                )
            );
        }
        insert listOrders;
    }

    public static void insertAccountsAndTasks(integer size) {
        List<Account> listAccount = new List<Account>();
        for (integer i = 0; i < size; i++) {
            listAccount.add(new Account(Name = 'Account with no task ' + i));
        }
        insert listAccount;

        listAccount.clear();
        for (integer i = 0; i < size; i++) {
            listAccount.add(new Account(Name = 'Account with task ' + i));
        }
        insert listAccount;

        List<Task> tasks = new List<Task>();
        for (Account acc : listAccount) {
            tasks.add(new Task(whatId = acc.Id, Subject = 'Email'));
        }
        insert tasks;
    }
}
