trigger FolioEventTrigger on FolioEvent__c (after insert, after delete, after update, after undelete) {
    map<Id,String> IssueNames = new map<Id,String>();
    Set<Id> oppIds = new Set<Id>();
    Set<Id> leadIds = new Set<Id>();
    Set<Id> accountIds = new Set<Id>();
    DateTime eventTime;
    if(Trigger.isAfter && !Util.inFolioEventTrigger){
        Util.inFolioEventTrigger = true;
    
        List<FolioEvent__c> eventsToProcess = (Trigger.isDelete ? Trigger.old : Trigger.new);

        for(FolioEvent__c event : eventsToProcess){
            if(eventTime > event.CreatedDate || eventTime==null)
                eventTime=event.CreatedDate;
            
            if(event.Opportunity__c != null){
                oppIds.add(event.Opportunity__c);
                if(IssueNames.get(event.Opportunity__c)!=null)
                    IssueNames.put(event.Opportunity__c,IssueNames.get(event.Opportunity__c)+', '+ event.issueName__c);
                else
                    IssueNames.put(event.Opportunity__c,event.issueName__c);
            }

            if(event.Lead__c != null){
                leadIds.add(event.Lead__c);
                if(IssueNames.get(event.Lead__c)!=null)
                    IssueNames.put(event.Lead__c,IssueNames.get(event.Opportunity__c)+', '+ event.issueName__c);
                else
                    IssueNames.put(event.Lead__c,event.issueName__c);
            }

            if(event.Account__c != null){
                accountIds.add(event.Account__c);
                if(IssueNames.get(event.Account__c)!=null)
                    IssueNames.put(event.Account__c,IssueNames.get(event.Opportunity__c)+', '+ event.issueName__c);
                else
                    IssueNames.put(event.Account__c,event.issueName__c);
            }
            
        }

        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        Map<Id, Lead> leadMap = new Map<Id, Lead>();
        Map<Id, Account> accountMap = new Map<Id, Account>();
        
        if(!oppIds.isEmpty()){
            oppMap = new Map<Id, Opportunity>([SELECT Id, (SELECT Id, eventTime__c, Next_Event_Time__c FROM FolioEvents__r ORDER BY eventTime__c) FROM Opportunity WHERE Id in :oppIds]);
        }

        if(!leadIds.isEmpty()){
            leadMap = new Map<Id, Lead>([SELECT Id, (SELECT Id, eventTime__c, Next_Event_Time__c FROM FolioEvents__r ORDER BY eventTime__c) FROM Lead WHERE Id in :leadIds]);
        }

        if(!accountIds.isEmpty()){
            accountMap = new Map<Id, Account>([SELECT Id, (SELECT Id, eventTime__c, Next_Event_Time__c FROM FolioEvents__r ORDER BY eventTime__c) FROM Account WHERE Id in :accountIds]);
        }

        Map<Id, FolioEvent__c> updateEventsMap = new Map<Id, FolioEvent__c>();

        for(FolioEvent__c event : eventsToProcess){
            List<FolioEvent__c> eventsList;

            if(event.Opportunity__c != null && event.eventTime__c != null){
                eventsList = oppMap.get(event.Opportunity__c).FolioEvents__r;
            } else if(event.Lead__c != null && event.eventTime__c != null){
                eventsList = leadMap.get(event.Lead__c).FolioEvents__r;
            } else if(event.Account__c != null && event.eventTime__c != null){
                eventsList = accountMap.get(event.Account__c).FolioEvents__r;
            }

            if(eventsList != null && eventsList.size() > 1){
                for(Integer i = 0; i < eventsList.size() - 1; i++){
                    if(eventsList.get(i).Next_Event_Time__c != eventsList.get(i + 1).eventTime__c){
                        eventsList.get(i).Next_Event_Time__c = eventsList.get(i + 1).eventTime__c;
                        updateEventsMap.put(eventsList.get(i).Id, eventsList.get(i));
                    }
                }
            }
        }

        update updateEventsMap.values();


        //create concatenated list of folios presented in description as there could be multiple
        //if lead, populate WhoId
    if(trigger.isInsert){
       list<Task> Activities = [Select Id,ActivityDate,OwnerId,LastModifiedDate,Description,WhoId,WhatId from Task where OwnerId = :System.UserInfo.getUserId() and WhoId=:leadIds and LastModifiedDate >= :eventTime and subject='Adobe DPS Presentation'];
        Activities.addAll([Select Id,ActivityDate,OwnerId,LastModifiedDate,Description,WhoId,WhatId from Task where OwnerId = :System.UserInfo.getUserId() and WhatId=:oppIds and LastModifiedDate >= :eventTime and subject='Adobe DPS Presentation']);
        Activities.addAll([Select Id,ActivityDate,OwnerId,LastModifiedDate,Description,WhoId,WhatId from Task where OwnerId = :System.UserInfo.getUserId() and WhatId=:accountIds and LastModifiedDate >= :eventTime and subject='Adobe DPS Presentation']);    

        map<Id,Task> activitymap = new map<Id,Task>();   
        for(Task t : Activities){
            if(t.WhoId!=null)
                activitymap.put(t.WhoId,t);
            else
                activitymap.put(t.WhatId,t);
                
        }
    

        Task task = new task();
        for(Id parentId : IssueNames.keyset()){
           if(activitymap.get(parentId)!=null){
                String descr;
                if(activitymap.get(parentId).description != null && IssueNames.get(parentId) != null && !activitymap.get(parentId).description.contains(IssueNames.get(parentId))){
                    descr = activitymap.get(parentId).description + ', '+IssueNames.get(parentId);
                }
                task = activitymap.get(parentId);
                if(activitymap.get(parentId).description != null && IssueNames.get(parentId) != null && !activitymap.get(parentId).description.contains(IssueNames.get(parentId))){
                    task.Description = descr;
                }
            }else
                task = new Task(Subject='Adobe DPS Presentation', ActivityDate=System.today(),Status='Completed', description =  system.UserInfo.getName() + ' presented '+IssueNames.get(parentId));
 
            if(parentId != null && parentId.getSObjectType().getDescribe().getName()=='Lead')
                task.WhoId = parentId;
            else
                task.WhatId = parentId;
       }    
        upsert task; 
        }
            }
}