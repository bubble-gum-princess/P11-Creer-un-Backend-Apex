trigger OrderWithProduct on Order(before update, after delete) {
    if (Trigger.isUpdate && Trigger.isBefore) {
        List<Order> newOrders = new List<Order>(Trigger.new);
        OrderService.orderHaveProducts(Trigger.oldMap, newOrders);
    }

    if (Trigger.isdelete && Trigger.isafter) {
        List<Order> oldOrders = Trigger.old;
        OrderService.accountWithDeletedOrders(Trigger.old);
    }

}
