public class COVA_ProbabilityTriggerHandler {
    
    private static COVA_ProbabilityTriggerHandler handlerInstance = new COVA_ProbabilityTriggerHandler();
    
    private COVA_ProbabilityTriggerHandler () {
        
    }

    //test comments
    
    public static COVA_ProbabilityTriggerHandler getInstance () {
        return handlerInstance;
    }
    
    public void triggerExecuting (List<Opportunity> opportunities) {
        
        List<COVA_Project__c> projects = new List<COVA_Project__c>();  
        
        Map<Id, Id> accConMap = new Map<Id,Id>();
        
        Set<String> projectsId = new Set<String>();  
        
        for(COVA_Project__c index : [SELECT Id,COVA_Opportunity__c FROM COVA_Project__c WHERE COVA_Opportunity__c != null]){
            projectsId.add(index.COVA_Opportunity__c);
        }        
        
        for(Account acc : [SELECT Id, COVA_Primarycontact__c FROM Account WHERE COVA_Primarycontact__c != null]){
            accConMap.put(acc.Id, acc.COVA_Primarycontact__c);
        }
        
        for(Opportunity opp : opportunities){            
            if(opp.Probability > 80 && !projectsId.contains(opp.Id)){
                
                COVA_Project__c projNew = new COVA_Project__c(Name = opp.Name,                                                              
                                                              COVA_Description__c = opp.Description,
                                                              COVA_Opportunity__c = opp.Id,                                                            
                                                              COVA_PrimaryContact__c = accConMap.get(opp.AccountId));
                projects.add(projNew);
            }
        } 
        
        try{
            insert projects;
        }
        
        catch(Exception e){
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,e.getStackTraceString());
           ApexPages.addMessage(myMsg);
        }
    }
    
}