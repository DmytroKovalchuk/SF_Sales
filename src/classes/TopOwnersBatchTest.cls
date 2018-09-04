@isTest
private class TopOwnersBatchTest {
    
    @isTest static void testTopOwners() {
        DPS__c dpsSettings = DPS__c.getOrgDefaults();
        dpsSettings.Top_Percent__c = 10.0;
        dpsSettings.Time_Period__c = 'Current FY';
        upsert dpsSettings;

        Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        Account account1 = new Account(Name = 'Test');
        insert account1;

        List<User> userList = new List<User>();

        User user1 = new User(Alias = 'u1', LastName = 'User1', FirstName = 'Test', Email = 'user1@test.com', 
                            EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', ProfileId = profile1.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='topuser1@test.com');
        userList.add(user1);

        User user2 = new User(Alias = 'u2', LastName = 'User2', FirstName = 'Test', Email = 'user2@test.com', 
                            EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', ProfileId = profile1.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='topuser2@test.com');
        userList.add(user2);

        User user3 = new User(Alias = 'u3', LastName = 'User3', FirstName = 'Test', Email = 'user3@test.com', 
                            EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = profile1.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='top@test.com');
        userList.add(user3);

        insert userList;

        List<Opportunity> oppList = new List<Opportunity>();
        Opportunity opp1 = new Opportunity(
            Name = 'Opp1',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Amount = 1000,
            Owner = user1
        );
        oppList.add(opp1);

        Opportunity opp2 = new Opportunity(
            Name = 'Opp2',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Amount = 1000,
            Owner = user1
        );
        oppList.add(opp2);

        Opportunity opp3 = new Opportunity(
            Name = 'Opp3',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Amount = 1000,
            Owner = user1
        );
        oppList.add(opp3);

        Opportunity opp4 = new Opportunity(
            Name = 'Opp4',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Amount = 1000,
            Owner = user2
        );
        oppList.add(opp4);

        Opportunity opp5 = new Opportunity(
            Name = 'Opp5',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Amount = 10,
            Owner = user3
        );
        oppList.add(opp5);
        insert(oppList);

        Test.startTest();
        Database.executeBatch(new TopOwnersBatch());
        Test.stopTest();

        System.debug('Top sales people = ' + DPS__c.getOrgDefaults().Top_Salespeople__c);
        System.assertNotEquals(null, DPS__c.getOrgDefaults().Top_Salespeople__c);
    }
    
}