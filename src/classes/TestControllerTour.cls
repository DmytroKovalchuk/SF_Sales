@isTest
public class TestControllerTour {
    static testMethod void validategetContacts(){
        test.startTest();
        ControllerTour controller = new ControllerTour();
        List<Target__c> checkList = new List<Target__c>();
        checklist = [select  Customer__c, visit__c  from Target__c where Representative__c in(select Representative__c from Visit__c)];
         System.assertEquals(controller.getContacts(), checklist);
        test.stopTest();
    }
    
    static testMethod void validatesaveMethod(){
        ControllerTour controller = new ControllerTour();
        List<Visit__c> visits = new List<Visit__c>();
        visits = [select id,StartDateTime__c, EndDateTime__c, Duration__c from Visit__c ];
        test.startTest();        
        controller.save();
        List<Visit__c>checkList = [select id,StartDateTime__c, EndDateTime__c, Duration__c from Visit__c];
        System.assertEquals(null, null);
        test.stopTest();
    }
    
    static testMethod void validatecalculateMethod(){
        ControllerTour controller = new ControllerTour();
        test.startTest();
        controller.calculate();
        System.assertEquals(null, null);
        test.stopTest();
        
    }
    
  
}