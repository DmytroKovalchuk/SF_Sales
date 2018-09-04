@isTest
private class postFolioEventsTest {
	
	@isTest static void testPostFolioEvents() {
		Account acct = new Account(
			Name = 'Test Account');
		insert acct;

		Opportunity opp = new Opportunity(
			Name = 'Test Opp',
			AccountId = acct.Id,
			StageName = 'Prospecting',
			CloseDate = date.today());
		insert opp;

		Lead testLead = new Lead(
			LastName = 'Lead',
			Email = 'testLead@codescience.com',
			Company = 'CodeScience'
		);
		insert testLead;

		List<DPS_Event__c> eventList = new List<DPS_Event__c>();
		eventList.add(new DPS_Event__c(Name = 'App Close', Event_Selected__c = false));
		eventList.add(new DPS_Event__c(Name = 'App Startup', Event_Selected__c = false));
		eventList.add(new DPS_Event__c(Name = 'Contet Browse', Event_Selected__c = false));
		eventList.add(new DPS_Event__c(Name = 'Content Exit', Event_Selected__c = false));
		eventList.add(new DPS_Event__c(Name = 'Content View', Event_Selected__c = true));
		eventList.add(new DPS_Event__c(Name = 'End of article reached', Event_Selected__c = false));
		eventList.add(new DPS_Event__c(Name = 'Issue Download Started', Event_Selected__c = false));
		eventList.add(new DPS_Event__c(Name = 'Overlay Started', Event_Selected__c = false));
		eventList.add(new DPS_Event__c(Name = 'Overlay Stopped', Event_Selected__c = false));
		upsert eventList;

		postFolioEvent.doPost('123', '456', 'Content View', dateTime.now(), 'testIssue', 'articleTitle', opp.Id);
		postFolioEvent.doPost('123', '456', 'Content View', dateTime.now(), 'testIssue', 'articleTitle', acct.Id);
		postFolioEvent.doPost('123', '456', 'Content View', dateTime.now(), 'testIssue', 'articleTitle', testLead.Id);

		FolioEvent__c testEvent = [SELECT Id FROM FolioEvent__c LIMIT 1];
		System.assertNotEquals(null, testEvent);
	}
	
}