@RestResource(urlMapping='/postFolioEvent')
global with sharing class postFolioEvent{
 
    @HttpPost
    global static void doPost(String stackId, String issueId, String eventName, DateTime eventTime, String issueName, String articleStackTitle, 
                              String parentId
                              ){
        String opportunityId;
        String leadId;
        String accountId;
        String folioName;
        ID folioId;
                                  
        //Check for opportunity
        if(parentId.substring(0, 3) == '006' ){
            opportunityId = parentId;
        //Check for lead
        } else if(parentId.substring(0, 3) == '00Q'){
            leadId = parentId;
        //Check for account
        } else if(parentId.substring(0, 3) == '001'){
            accountId = parentId;
        }

        //Set<String> dpsEvents = DPS_Event__c.getAll().keySet();
        Set<String> selectedEvents = new Set<String>();
        for(DPS_Event__c event : DPS_Event__c.getall().values()){
            if(event.Event_Selected__c){
                selectedEvents.add(event.Name);
            }
        }

        if(selectedEvents.contains(eventName)){
            FolioEvent__c event = new FolioEvent__c(
                ArticleStackTitle__c = articleStackTitle,
                EventName__c = eventName,
                EventTime__c = eventTime,
                IssueName__c = issueName,
                IssuerId__c = issueId,
                Opportunity__c = opportunityId,
                Lead__c = leadId,
                Account__c = accountId,
                StackId__c = stackId
            );
            insert event;
        }

    }
}