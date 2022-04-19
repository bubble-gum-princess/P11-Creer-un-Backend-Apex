trigger OrderWithProduct on Order (before update, after delete) {
    if(trigger.isUpdate){
        if(trigger.isBefore){
            List<Order> listOrderStatusToActiveFailed = new List<Order>();
            List<Order> listOrdersDraftToActive = new List<Order>();
            Map<Id,Order> oldOrders = new Map<Id,Order>(trigger.old);
            List<Order> newOrders = new List<Order>(trigger.new);
            for(Order order : newOrders){
                Order oldOrder = oldOrders.get(order.Id);
                Boolean orderStatusIsChanged = oldOrder.Status == 'Draft' && order.Status == 'Active';
                if(orderStatusIsChanged){
                    
                   listOrdersDraftToActive.add(order);
                    
                }
                
            }
            if(listOrdersDraftToActive.size() > 0){
                
                List<OrderItem> listProduct = [Select OrderId FROM OrderItem
                                                  WHERE OrderId IN : new Map<Id,Order>(listOrdersDraftToActive).keySet()];
                List<Id> listOrderIds = new List<Id>();
                for(OrderItem oi :listProduct){
                    listOrderIds.add(oi.OrderId);
                }
                for(Order o : listOrdersDraftToActive){
                    if(!listOrderIds.contains(o.Id)){
                        o.addError('Veuillez saisir des produits avant activer ordre' );
                        listOrderStatusToActiveFailed.add(o);  
                    }   
                }
                
            }
        }
    }
    
    if(trigger.isdelete){
        if(trigger.isafter){
            //List<Account> listAccActive = new List<Account>();
            List<Order> oldOrders = (trigger.old);
            
            Set<Id> listAccountIdsFromOld = new Set<Id>();
            for(Order o : oldOrders){
                listAccountIdsFromOld.add(o.AccountId);
            }
            
            List<Account> accounts =[SELECT Id FROM Account
                                 WHERE Id NOT IN (SELECT accountId from Order)
                                    AND Id IN :listAccountIdsFromOld 
                                     ANd Active__c = 'true' ];
            
            List<Account> idAccountsToUpdate = new List<Account>();

          	 for(Account a : accounts){
                 
                 a.active__c = 'false';      
				idAccountsToUpdate.add(a);
            }
            
             update accounts;

            
           
            
            }
           

            
        }
    }