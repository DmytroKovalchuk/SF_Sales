@isTest
private class LeadTriggerTest {
	
	@isTest static void testLeadTrigger() {
		Lead lead1 = new Lead(FirstName = 'Test', LastName = 'Lead1', Email = 'testlead1@codescience.com', Company = 'Test Co.');
		insert lead1;

		Lead lead2 = new Lead(FirstName = 'Test', LastName = 'Lead2', Email = 'testlead2@codescience.com', Company = 'Test Co.');
		insert lead2;

		FolioEvent__c event1 = new FolioEvent__c(Lead__c = lead1.Id);
		insert event1;

		FolioEvent__c event2 = new FolioEvent__c(Lead__c = lead2.Id);
		insert event2;

		DPS__c dps = new DPS__c(Folio_Conversion__c = true);
		insert dps;

		Database.LeadConvert lc1 = new Database.LeadConvert();
		Database.LeadConvert lc2 = new Database.LeadConvert();
		lc1.setLeadId(lead1.Id);
		lc2.setLeadId(lead2.Id);

		LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
		lc1.setConvertedStatus(convertStatus.MasterLabel);
		lc2.setConvertedStatus(convertStatus.MasterLabel);

		lc2.setDoNotCreateOpportunity(true);

		Database.convertLead(lc1);
		Database.convertLead(lc2);

		Contact testContact1 = [SELECT Id FROM Contact WHERE LastName = 'Lead1'];
		FolioEvent__c testEvent1 = [SELECT Id, Opportunity__c FROM FolioEvent__c WHERE Id = :event1.Id];
		System.assertNotEquals(null, testEvent1.Opportunity__c);
	}
}