@isTest
public class TargetTrigetScheduleTest {   
    
    
    private static List<Contact> initContact(){
        List<Contact> contacts = new List<Contact>{ 
            new Contact(FirstName='Contact1', LastName ='Kov1'),
                new Contact(FirstName= 'Contact2',LastName ='Kov2'),
                new Contact(FirstName='Contact3',LastName ='Kov3')    
                };                    
                    
                    insert contacts;
        
        return contacts;        
    }  
    
    static  Map<Id, List<Id>> mapInitialization(){
        Map<Id, List<Id>> initMap = new Map<Id, List<Id>>();
        for(Target__c index : [select Customer__c, Representative__c from Target__c ]){
            if(initMap.containsKey(index.Customer__c)){
                initMap.get(index.Customer__c).add(index.Representative__c);
            }
            else {
                List<Id> listToPut = new List<Id>();
                listToPut.add(index.Representative__c);
                initMap.put(index.Customer__c, listToPut); 
            }
        }
        return initMap;
    }
    
    @isTest
    static void executeInsertTest (){  
        
        List<User> users = [select Id from User];
        List<Contact> contacts = initContact();       
        
        List<Target__c> targetList = new List<Target__c>();
        
        for(Integer i = 0; i < contacts.size(); i++){
            targetList.add(new Target__c(Representative__c=users.get(i).Id,
                                         Customer__c=contacts.get(i).Id));
        }        
        
        insert targetList;
        
        Map<Id, List<Id>> initMap = mapInitialization();      
        
        List<Contact> targetContact = [select Targets__c from Contact];        
        
        for(Contact index : targetContact){          
            
            if(initMap.containsKey(index.Id) ){              
                System.assert(index.Targets__c.length() == initMap.get(index.id).size()*String.valueOf(index.Id).length(), 'Length of User id is not equal to length of Targets__c');
                for(Id eachId : initMap.get(index.Id)){
                    System.assert(index.Targets__c.contains(eachId), 'Can not find User id (' + eachId + ')  in Targets (' + index.Targets__c + ')');
                }                
            }
            
            else  System.assert(String.isBlank(index.Targets__c), 'Contact has a Targets__c record and it is o record in Target__c table'); 
            
        }     
    }
    
    @isTest
    static void executeDeleteTest(){
        
        List<User> users = [select Id from User];
        List<Contact> contacts = initContact();       
        
        List<Target__c> targetList = new List<Target__c>();
        
        for(Integer i = 0; i < contacts.size(); i++){
            targetList.add(new Target__c(Representative__c=users.get(i).Id,
                                         Customer__c=contacts.get(i).Id));
        }        
        
        insert targetList;
        
        List<Target__c> target2 = [SELECT Id FROM Target__c limit 2];
        
        System.Database.delete(target2);       
        
        Map<Id, List<Id>> initMap = mapInitialization();
        
        List<Contact> targetContact = [select Targets__c from Contact];        
        
        for(Contact index : targetContact){          
            
            if(initMap.containsKey(index.Id) ){                
                System.assert(index.Targets__c.length() == initMap.get(index.id).size()*String.valueOf(index.Id).length(), 'Length of User id is not equal to length of Targets__c');
                
                for(Id eachId : initMap.get(index.Id)){
                    System.assert(index.Targets__c.contains(eachId), 'Can not find User id (' + eachId + ')  in Targets (' + index.Targets__c + ')');
                }
            }    
            
            else  System.assert(String.isBlank(index.Targets__c), 'Contact has a Targets__c record and it is o record in Target__c table');            
        }    
    }
    
    @isTest
    static void executeupdateTest(){
        
        List<User> users = [select Id from User];
        List<Contact> contacts = initContact();       
        
        List<Target__c> targetList = new List<Target__c>();
        
        for(Integer i = 0; i < contacts.size(); i++){
            targetList.add(new Target__c(Representative__c=users.get(i).Id,
                                         Customer__c=contacts.get(i).Id));
        }    
        
        insert targetList;
        
        
        Target__c updateTarget = [select Representative__c, Customer__c from Target__c where id = : targetList.get(0).Id limit 1];
        updateTarget.Representative__c = targetList.get(1).Representative__c;  
        
        System.Database.update(updateTarget);      
        
        Map<Id, List<Id>> initMap = mapInitialization();          
        
        List<Contact> targetContact = [select Targets__c from Contact];        
        List<Target__c> target = [select Customer__c,Representative__c from Target__c];
     
        for(Contact index : targetContact){
            
            if(initMap.containsKey(index.Id) ){               
                System.assert(index.Targets__c.length() == initMap.get(index.id).size()*String.valueOf(index.Id).length(), 'Length of User id is not equal to length of Targets__c');
                for(Id eachId : initMap.get(index.Id)){
                    System.assert(index.Targets__c.contains(eachId), 'Can not find User id (' + eachId + ')  in Targets (' + index.Targets__c + ')');
                }
                
            }
            
            else  System.assert(String.isBlank(index.Targets__c), 'Contact has a Targets__c record and it is o record in Target__c table');           
        }        
    }  
}