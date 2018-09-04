trigger COVA_ProbabilityTrigger on Opportunity (after insert, after update) {
    
    private final COVA_ProbabilityTriggerHandler handlerInstance = COVA_ProbabilityTriggerHandler.getInstance();
    
    
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
       handlerInstance.triggerExecuting(Trigger.new);
    }
}