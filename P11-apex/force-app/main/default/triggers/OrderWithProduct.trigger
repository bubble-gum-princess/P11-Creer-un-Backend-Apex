trigger OrderWithProduct on Order (before update, after delete) {
    if(trigger.isUpdate && trigger.isBefore){

            List<Order> newOrders = new List<Order>(trigger.new);
            OrderService.orderHaveProducts(trigger.oldMap, newOrders);
        
    }
    
    if(trigger.isdelete && trigger.isafter){
        
            //List<Account> listAccActive = new List<Account>();
            List<Order> oldOrders = (trigger.old);
            
            OrderService.accountWithDeletedOrders(trigger.old);
            
           
            
            }
           

            
        
    }