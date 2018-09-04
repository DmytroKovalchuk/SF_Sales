public class VisitTriggerHandler { 
    
    public void triggerExecute(Visit__c[] visitArray){        
        //query to take valid values from Target__c
        List<Target__c> listIdCustomReference = targetInit(visitArray);

        if(listIdCustomReference.size() == 0){
            System.assert(false,'Record Customer and Representative does not exist');  
        }          
        //double loop to check all visits whith Target__c Id
          
        for(Visit__c index1 : visitArray){  
            boolean flag = true;          
            for(Target__c index2 : listIdCustomReference ){                 
                if(index1.Customer__c == index2.Customer__c && index1.Representative__c == index2.Representative__c){                 
                    flag = false;
                    break;                                  
                }
            }
            if(flag){
                System.assert(false,'Please insert correct Customer or Representative');
            }
        }     
        
    }
    
    private List<Target__c> targetInit(Visit__c [] visitArray ){       
      
           List<Id> visitsCId = new List<Id>();
           List<Id> visitsRId = new List<Id>();
        
        for(Visit__c index : visitArray){
            visitsCId.add(index.Customer__c);
            visitsRId.add(index.Representative__c); 
        }
           List<Target__c> listIdCustomReference = [SELECT Customer__c,Representative__c FROM Target__c WHERE Customer__c in:visitsCId and
                                                   Representative__c in:visitsRId];        
        return listIdCustomReference;
    }
    
}