@isTest
public class VisitTriggerHandlerTest {  
   
    private static List<Contact> initContact(){
        List<Contact> contacts = new List<Contact>{ 
            new Contact(FirstName='Contact1', LastName ='Kov1'),
                new Contact(FirstName= 'Contact2',LastName ='Kov2'),
                new Contact(FirstName='Contact3',LastName ='Kov3')    
                };                
                    insert contacts;              
        return contacts;        
    } 
    
    static List<Target__c> initTarget(){
        List<User> users = [select Id from User limit 3];        
        List<Contact> contacts = initContact();        
        List<Target__c> targetList = new List<Target__c>();        
        for(Integer i = 0; i < contacts.size(); i++){
            targetList.add(new Target__c(Representative__c=users.get(i).Id,
                                         Customer__c=contacts.get(i).Id));
        }  
        insert targetList;        
        return targetList;
    }      
    
    @isTest()
    static void insertUpdateExecuteCorrectData(){ 
        Test.startTest();
        List<Target__c> targetList = initTarget();      
        for(Integer i = 0; i < targetList.size(); i++){
            Visit__c visitToInsert = new Visit__c(Representative__c=targetList.get(i).Representative__c,
                                                  Customer__c=targetList.get(i).Customer__c);
            //listVisitToInsertAll.add(visitToInsert);
            insert visitToInsert;            
            Visit__c updateVisit = [SELECT Representative__c, Customer__c FROM Visit__c	where id = :visitToInsert.Id];
            System.assert(updateVisit != null,'Insert single visit work incorrect.');
            updateVisit.Representative__c = targetList.get(0).Representative__c;
            updateVisit.Customer__c = targetList.get(0).Customer__c;
            //listVisitToUpdateAll.add(updateVisit);
            update updateVisit;
            Visit__c updateVisitAfter = [SELECT Representative__c, Customer__c FROM Visit__c	where id = :visitToInsert.Id];
            System.assert(updateVisit.Customer__c == updateVisitAfter.Customer__c, 'After update is incorrect Customer');
            System.assert(updateVisit.Representative__c == updateVisitAfter.Representative__c, 'After update is incorrect Re');
            delete updateVisit;
        }      
        
        Test.stopTest();      
        
    }
    @isTest
    static void insertUpdateExecuteCorrectDataAll(){
        Test.startTest();
        List<Visit__c> visitToInsertAll = new List<Visit__c>();  
        List<Visit__c> visitToUpdateAll = new List<Visit__c>();
        List<Target__c> targetList = initTarget();
        
        for(Integer i = 0; i < targetList.size(); i++){
            Visit__c visitToInsert = new Visit__c(Representative__c=targetList.get(i).Representative__c,
                                                  Customer__c=targetList.get(i).Customer__c);
            visitToInsertAll.add(visitToInsert);             
        }        
        System.Database.insert(visitToInsertAll);
        List<Visit__c> selList = [SELECT Representative__c, Customer__c FROM Visit__c];       
        System.assert(visitToInsertAll == selList, 'Exception during add List of visits');
        for(Visit__c ind : selList){
            ind.StartDateTime__c=DateTime.now();
            visitToUpdateAll.add(ind);
        }       
        System.Database.update(visitToUpdateAll);
        List<Visit__c> selListAf = [SELECT Representative__c, Customer__c,Id,StartDateTime__c FROM Visit__c];       
        System.assert(String.valueOf(visitToUpdateAll) == String.valueOf(selListAf), 'Exception during add List of visits');       
        Test.stopTest();      
        
    }
    
    @isTest
    static void insertExecuteIncorrectData(){        
        List<Target__c> targetList = initTarget();                
        if(targetList.size() <= 1){
            System.assert(false, 'Incorrect data must be more than one element');
        }
        
        Visit__c visitToInsert = new Visit__c(Representative__c=targetList.get(targetList.size()-1).Representative__c,
                                              Customer__c=targetList.get(0).Customer__c);         
        Visit__c visitToUp = new Visit__c (Representative__c=targetList.get(0).Representative__c,
                                           Customer__c=targetList.get(0).Customer__c);
        insert visitToUp;
        Visit__c incorToUpRep = [SELECT Representative__c, Customer__c FROM Visit__c where id=:visitToUp.id];
        Visit__c incorToUpCus = incorToUpRep;
        incorToUpRep.Representative__c = targetList.get(2).Representative__c;
        incorToUpCus.Customer__c = targetList.get(2).Customer__c;
        try{
            insert visitToInsert;          
        }  
        
        catch(System.AssertException e){           
            System.assertEquals('Please insert correct Customer or Representative', e.getMessage(), '@@@@@Incorrect'); 
            System.assertEquals('Record Customer and Representative does not exist', e.getMessage(), '@@@@@Incorrect'); 
        }
        
        catch(System.DmlException e){
            //System.assertEquals('Please insert correct Customer or Representative', e.getMessage(), '@@@@@Incorrect'); 
            System.debug('System.DmlException catched' + e.getMessage());
        }
        System.debug('Test dont work complitely');
        
    }
    
    @isTest
    static void updateIncorrectDataRep(){
        List<Target__c> targetList = initTarget();                
        if(targetList.size() <= 1){
            System.assert(false, 'Incorrect data must be more than one element');
        }             
        Visit__c visitToUp = new Visit__c (Representative__c=targetList.get(0).Representative__c,
                                           Customer__c=targetList.get(0).Customer__c);
        insert visitToUp;
        
        Visit__c incorToUpRep = [SELECT Representative__c, Customer__c FROM Visit__c where id=:visitToUp.id];
        Visit__c incorToUpCus = incorToUpRep;
        incorToUpRep.Representative__c = targetList.get(2).Representative__c;
       
        incorToUpCus.Customer__c = targetList.get(2).Customer__c;

        try{
            update incorToUpRep;
        }
        
        catch(System.AssertException e){           
            System.debug('AssVVVVVVVV' + e.getMessage());
            System.assertEquals('Please insert correct Customer or Representative', e.getMessage(), '@@@@@Incorrect'); 
            System.assertEquals('Record Customer and Representative does not exist', e.getMessage(), '@@@@@Incorrect'); 
            System.debug('AssVVVVVVVV' + e.getMessage());
       }
        
        catch(System.DmlException e){
            System.debug('DmlVVVVVVVV' + e.getMessage());
        }
         System.debug('Test dont work complitely');
    }
    
    @isTest
    static void updateIncorrectDataCus(){
        List<Target__c> targetList = initTarget();                
        if(targetList.size() <= 1){
            System.assert(false, 'Incorrect data must be more than one element');
        }             
        Visit__c visitToUp = new Visit__c (Representative__c=targetList.get(0).Representative__c,
                                           Customer__c=targetList.get(0).Customer__c);
        insert visitToUp;
        Visit__c incorToUpRep = [SELECT Representative__c, Customer__c FROM Visit__c where id=:visitToUp.id];
        Visit__c incorToUpCus = incorToUpRep;          
        incorToUpCus.Customer__c = targetList.get(2).Customer__c;
        try{
            update incorToUpCus;
        }
        
        catch(System.AssertException e){           
            System.assertEquals('Please insert correct Customer or Representative', e.getMessage(), '@@@@@Incorrect'); 
            System.assertEquals('Record Customer and Representative does not exist', e.getMessage(), '@@@@@Incorrect'); 
        }
        
        catch(System.DmlException e){
            System.debug('System.DmlException catched' + e.getMessage());
        } 
        System.debug('Test dont work complitely');
    }
    
    
    @isTest
    static void InsertExecuteIncorrectDataAll(){
        Test.startTest();
        List<Target__c> targetList = initTarget();
        Integer k = 0;
        List<Visit__c> visits = new List<Visit__c>();
        System.assert(targetList.size() >=2, 'Excepton during initializing Target__c');
        for(Integer i = 0; i < targetList.size(); i++){
            Visit__c visitToInsert = new Visit__c(Representative__c=targetList.get(i).Representative__c,
                                                  Customer__c=targetList.get(targetList.size()-i-1).Customer__c);
            visits.add(visitToInsert);             
        }
        try{
            insert visits;
        }
        
        catch(System.AssertException e){           
            System.assertEquals('Please insert correct Customer or Representative', e.getMessage(), '@@@@@Incorrect'); 
            System.assertEquals('Record Customer and Representative does not exist', e.getMessage(), '@@@@@Incorrect'); 
        }
        
        catch(System.DmlException e){
            System.debug('System.DmlException catched' + e.getMessage());
        }    
         System.debug('Test dont work complitely');
        Test.stopTest();
    }
    
    @isTest
    static void updateExecuteIncorrectDataAllRep(){
        Test.startTest();
        List<Target__c> targetList = initTarget();
        Integer k = 0;
        List<Visit__c> visitsCorrect = new List<Visit__c>();
        System.assert(targetList.size() >=2, 'Excepton during initializing Target__c');
        for(Integer i = 0; i < targetList.size(); i++){
            Visit__c visitToInsert = new Visit__c(Representative__c=targetList.get(i).Representative__c,
                                                  Customer__c=targetList.get(i).Customer__c);
            visitsCorrect.add(visitToInsert);             
        }       
        insert visitsCorrect;
        
        List<Visit__c> incorVisits = [SELECT Representative__c FROM Visit__c where id in:visitsCorrect];
        for(Visit__c index : incorVisits){
            index.Representative__c=targetList.get(0).Representative__c;
        }
        try{
            update incorVisits;
        }
        
        catch(System.AssertException e){           
            System.assertEquals('Please insert correct Customer or Representative', e.getMessage(), '@@@@@Incorrect'); 
            System.assertEquals('Record Customer and Representative does not exist', e.getMessage(), '@@@@@Incorrect'); 
        }
        
        catch(System.DmlException e){
            
            System.debug('QQQQQQQQQQQQQQQQSystem.DmlException catched' + e.getMessage());
        } 
        System.debug('Test dont work complitely');
        Test.stopTest();
    }
    
    @isTest
    static void updateExecuteIncorrectDataAllCus(){
        Test.startTest();
        List<Target__c> targetList = initTarget();
        Integer k = 0;
        List<Visit__c> visitsCorrect = new List<Visit__c>();
        System.assert(targetList.size() >=2, 'Excepton during initializing Target__c');
        for(Integer i = 0; i < targetList.size(); i++){
            Visit__c visitToInsert = new Visit__c(Representative__c=targetList.get(i).Representative__c,
                                                  Customer__c=targetList.get(i).Customer__c);
            visitsCorrect.add(visitToInsert);             
        }       
        insert visitsCorrect;
        
        List<Visit__c> incorVisits = [SELECT Representative__c FROM Visit__c where id in:visitsCorrect];
        for(Visit__c index : incorVisits){
            index.Customer__c=targetList.get(0).Customer__c;
        }
        try{
            update incorVisits;
        }
        
        catch(System.AssertException e){           
            System.assertEquals('Please insert correct Customer or Representative', e.getMessage(), '@@@@@Incorrect'); 
            System.assertEquals('Record Customer and Representative does not exist', e.getMessage(), '@@@@@Incorrect'); 
        }
        
        catch(System.DmlException e){
            System.debug('System.DmlException catched' + e.getMessage());
        }    
         System.debug('Test dont work complitely');
        
        Test.stopTest();
    }
}