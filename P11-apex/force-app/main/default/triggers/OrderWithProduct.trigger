trigger OrderWithProduct on Order(before update, after delete) {
    if (Trigger.isUpdate && Trigger.isBefore) {
        OrderService.orderHaveProducts(Trigger.oldMap, Trigger.newMap);
    }

    if (Trigger.isdelete && Trigger.isafter) {
        List<Order> oldOrders = Trigger.old;
        OrderService.accountWithDeletedOrders(Trigger.old);
    }

}
