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
    public static void orderHaveProducts(Map<Id, Order> oldOrders, List<Order> newOrders) {
        List<Order> listOrderStatusToActiveFailed = new List<Order>();
        List<Order> listOrdersDraftToActive = new List<Order>();
        for (Order order : newOrders) {
            if (oldOrders.get(order.Id).Status == 'Draft' && order.Status == 'Active') {
                listOrdersDraftToActive.add(order);
            }
        }
        if (listOrdersDraftToActive.size() > 0) {
            List<OrderItem> listProduct = [
                SELECT OrderId
                FROM OrderItem
                WHERE OrderId IN :new Map<Id, Order>(listOrdersDraftToActive).keySet()
            ];
            List<Id> listOrderIds = new List<Id>();
            for (OrderItem oi : listProduct) {
                listOrderIds.add(oi.OrderId);
            }
            for (Order o : listOrdersDraftToActive) {
                if (!listOrderIds.contains(o.Id)) {
                    o.addError('Veuillez saisir des produits avant activer ordre');
                    listOrderStatusToActiveFailed.add(o);
                }
            }
        }
    }
    public static void accountWithDeletedOrders(List<Order> oldOrders) {
        Set<Id> listAccountIdsFromOld = new Set<Id>();
        for (Order o : oldOrders) {
            listAccountIdsFromOld.add(o.AccountId);
        }

        List<Account> accounts = [
            SELECT Id
            FROM Account
            WHERE
                Id NOT IN (SELECT accountId FROM Order)
                AND Id IN :listAccountIdsFromOld
                AND Active__c = 'true'
        ];

        List<Account> idAccountsToUpdate = new List<Account>();

        for (Account a : accounts) {
            a.active__c = 'false';
            idAccountsToUpdate.add(a);
        }

        update accounts;
    }
}
