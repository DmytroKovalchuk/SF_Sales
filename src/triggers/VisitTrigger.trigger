trigger VisitTrigger on Visit__c (before insert, before update) {    
   
    Visit__c[] visitArray = Trigger.new;
    VisitTriggerHandler handler = new VisitTriggerHandler();
    handler.triggerExecute(visitArray);
}