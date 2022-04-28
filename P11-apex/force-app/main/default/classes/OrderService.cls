public with sharing class OrderService {
    public static void createNewTask(List<Account> accounts) {
        List<Task> Tasks = new List<Task>();
        for (Account a : accounts) {
            Task newTask = new Task();
            newTask.WhatId = a.Id;
            newTask.Subject = 'Call';
            newTask.Priority = 'Normale';
            newTask.Status = 'Nouvelle';
            newTask.ReminderDateTime = System.today() + 5;

            Tasks.add(newTask);
        }

        insert Tasks;
    }
    public static void orderHaveProducts(Map<Id, Order> oldOrders, Map<Id, Order> newOrders) {
        List<Order> orders = [
            SELECT Id, (SELECT Id FROM OrderItems)
            FROM Order
            WHERE Id IN :newOrders.values()
        ];
        for (Order anOrder : orders) {
            Order newOrder = newOrders.get(anOrder.Id);
            if (
                oldOrders.get(anOrder.Id).Status == 'Draft' &&
                newOrder.Status == 'Active' &&
                anOrder.OrderItems.isEmpty()
            ) {
                newOrder.addError('Veuillez saisir des produits avant activer la commande');
            }
        }
    }
    public static void accountWithDeletedOrders(List<Order> oldOrders) {
        Set<Id> listAccountIdsFromOld = new Set<Id>();
        for (Order o : oldOrders) {
            listAccountIdsFromOld.add(o.AccountId);
        }

        List<Account> idAccountsToUpdate = new List<Account>();

        for (Account a : [
            SELECT Id, (SELECT Id FROM Orders)
            FROM Account
            WHERE Id IN :listAccountIdsFromOld
        ]) {
            if (a.Orders.isEmpty()) {
                a.active__c = 'false';
                idAccountsToUpdate.add(a);
            }
        }

        update idAccountsToUpdate;
    }
}
