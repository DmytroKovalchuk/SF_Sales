trigger Lead on Lead (before update) {
	if(DPS__c.getOrgDefaults().Folio_Conversion__c){
		List<Id> folioLeadIds = new List<Id>();

		for(Lead lead : Trigger.new){
			if(lead.isConverted){
				folioLeadIds.add(lead.Id);
			}
		}

		List<FolioEvent__c> updateFolioEvents = new List<FolioEvent__c>();

		if(folioLeadIds.size() > 0){
			for(FolioEvent__c event : [SELECT Id, Lead__c FROM FolioEvent__c WHERE Lead__c in :folioLeadIds]){
				Lead eventLead = Trigger.newMap.get(event.Lead__c);
				if(eventLead.ConvertedOpportunityId != null){
					updateFolioEvents.add(new FolioEvent__c(Id = event.Id, Lead__c = null, Opportunity__c = eventLead.ConvertedOpportunityId));
				} else{
					updateFolioEvents.add(new FolioEvent__c(Id = event.Id, Lead__c = null, Account__c = eventLead.ConvertedAccountId));
				}
			}
		}

		update updateFolioEvents;
	}
}