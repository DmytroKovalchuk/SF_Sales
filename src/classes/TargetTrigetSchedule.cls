public class TargetTrigetSchedule { 
    
    private Map<Id,Contact> getValidMap (Target__c[] targets){        
        Map<Id,Contact> returnMap = new Map<Id,Contact>([select Id, Targets__c from Contact where Id in : initContacts(targets)]);    
        return returnMap;        
    } 
    
    private List<Id> initContacts (Target__c[] targets){
        if(targets.size() == 0){
            throw new MyClassException('Invald parameters');
        }
        List<Id> contacts = new List<Id>();
        
        for(Target__c index : targets){
            contacts.add(index.Customer__c);
        }      
        return contacts;
    }
    
    public void executeInsert (Target__c[] targets){
        
        Map<Id, Contact> mapC = getValidMap(targets);
        
        for(Target__c c : targets){           
            if(mapC.get(c.Customer__c).Targets__c == null  ){
                mapC.get(c.Customer__c).Targets__c = c.Representative__c;
            }
            
            else if(!mapC.get(c.Customer__c).Targets__c.contains(c.Representative__c) ) {
                mapC.get(c.Customer__c).Targets__c += c.Representative__c; 
            }          
        }
        try { 
            update mapC.values();
        }
        catch(DmlException e ) {
            System.debug('System exception during update list');
        } 
    }
    
    public void executeDelete(Target__c[] targets){       
        
        Map<Id, Contact> contacts = getValidMap(targets);
        
        //loop to delete record if it is exist
        for(Target__c c : targets){
            String res = contacts.get(c.Customer__c).Targets__c;
            
            if(res != null && res.contains(c.Representative__c) ){              
                String res1 =  contacts.get(c.Customer__c).Targets__c.remove(c.Representative__c);                
                contacts.get(c.Customer__c).Targets__c = res1;                                
            }           
        }       
        
        try { 
            update contacts.values();
        }
        catch(DmlException e ) {
            System.debug('System exception during update list');
        }      
    }
    
    public void executeUpdate(Target__c[] oldValues, Target__c[] newValues){    
        executeDelete(oldValues);
        executeInsert(newValues); 
    }
    
}