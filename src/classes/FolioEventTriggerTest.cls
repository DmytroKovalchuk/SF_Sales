@isTest
private class FolioEventTriggerTest {
    @isTest static void testFolioEventTrigger() {
        Account a = new Account(Name = 'Boss');
        insert a;
        
        Opportunity o = new Opportunity(Name='My Opp',AccountId=a.id,StageName='Closed/Won',CloseDate=Date.today());
        insert o;
        
        List<FolioEvent__c> folioEventList = new List<FolioEvent__c>();

        FolioEvent__c fe1 = new FolioEvent__c(Opportunity__c = o.id, issueName__c = 'Test Issue 3', eventTime__c=Datetime.Now().addMinutes(-2));
        folioEventList.add(fe1);

        FolioEvent__c fe2 = new FolioEvent__c(Opportunity__c = o.id, issueName__c = 'Test Issue 3', eventTime__c=Datetime.Now().addMinutes(-1));
        folioEventList.add(fe2);

        insert folioEventList;
        Util.inFolioEventTrigger = false;

        FolioEvent__c testFe1 = [SELECT Id, eventTime__c, Next_Event_Time__c FROM FolioEvent__c WHERE Id = :fe1.Id];
        FolioEvent__c testFe2 = [SELECT Id, eventTime__c, Next_Event_Time__c FROM FolioEvent__c WHERE Id = :fe2.Id];

        System.assertEquals(testFe1.Next_Event_Time__c, fe2.eventTime__c);
        System.assertEquals(testFe2.Next_Event_Time__c, null);

        FolioEvent__c fe3 = new FolioEvent__c(Opportunity__c = o.id, eventTime__c = System.Now());
        insert fe3;
        Util.inFolioEventTrigger = false;

        testFe2 = [SELECT Id, eventTime__c, Next_Event_Time__c FROM FolioEvent__c WHERE Id = :fe2.Id];
        FolioEvent__c testFe3 = [SELECT Id, eventTime__c, Next_Event_Time__c FROM FolioEvent__c WHERE Id = :fe3.Id];

        System.assertEquals(testFe2.Next_Event_Time__c, fe3.eventTime__c);
        System.assertEquals(testFe3.Next_Event_Time__c, null);

        delete testFe2;
        Util.inFolioEventTrigger = false;

        testFe1 = [SELECT Id, eventTime__c, Next_Event_Time__c FROM FolioEvent__c WHERE Id = :fe1.Id];
        System.assertEquals(testFe1.Next_Event_Time__c, fe3.eventTime__c);
    }

    @isTest static void testUpdate(){
        Account a = new Account(Name = 'Boss');
        insert a;
        
        Opportunity o = new Opportunity(Name='My Opp',AccountId=a.id,StageName='Closed/Won',CloseDate=Date.today());
        insert o;
        
        List<FolioEvent__c> folioEventList = new List<FolioEvent__c>();

        //Do this to disable the trigger
        Util.inFolioEventTrigger = true;

        FolioEvent__c fe1 = new FolioEvent__c(Opportunity__c = o.id, issueName__c = 'Test Issue 1', eventTime__c=Datetime.Now().addMinutes(-2));
        folioEventList.add(fe1);
        FolioEvent__c fe2 = new FolioEvent__c(Opportunity__c = o.id, issueName__c = 'Test Issue 2', eventTime__c=Datetime.Now().addMinutes(-1));
        folioEventList.add(fe2);
        FolioEvent__c fe3 = new FolioEvent__c(Opportunity__c = o.id, issueName__c = 'Test Issue 3', eventTime__c = System.Now());
        folioEventList.add(fe3);

        insert folioEventList;

        FolioEvent__c testFe1 = [SELECT Id, eventTime__c, Next_Event_Time__c FROM FolioEvent__c WHERE Id = :fe1.Id];
        FolioEvent__c testFe2 = [SELECT Id, eventTime__c, Next_Event_Time__c FROM FolioEvent__c WHERE Id = :fe2.Id];
        FolioEvent__c testFe3 = [SELECT Id, eventTime__c, Next_Event_Time__c FROM FolioEvent__c WHERE Id = :fe3.Id];

        System.assertEquals(null, fe1.Next_Event_Time__c);
        System.assertEquals(null, fe2.Next_Event_Time__c);
        System.assertEquals(null, fe3.Next_Event_Time__c);
        
        Util.inFolioEventTrigger = false;
        
        fe1.issueName__c = 'test1';
        fe2.issueName__c = 'test2';
        fe3.issueName__c = 'test3';

        update folioEventList;

        testFe1 = [SELECT Id, eventTime__c, Next_Event_Time__c FROM FolioEvent__c WHERE Id = :fe1.Id];
        testFe2 = [SELECT Id, eventTime__c, Next_Event_Time__c FROM FolioEvent__c WHERE Id = :fe2.Id];
        testFe3 = [SELECT Id, eventTime__c, Next_Event_Time__c FROM FolioEvent__c WHERE Id = :fe3.Id];

        System.assertEquals(fe2.eventTime__c, testFe1.Next_Event_Time__c);
        System.assertEquals(fe3.eventTime__c, testFe2.Next_Event_Time__c);
        System.assertEquals(null, testFe3.Next_Event_Time__c);
    }
}