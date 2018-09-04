@isTest
public class COVA_ProbabilityTriggerHandlerTest {
    
    testMethod static void executeValidData () {
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        Contact con = new Contact(LastName='Test Contact');
        con.AccountId = acc.Id;
        insert con;
        
        acc.COVA_Primarycontact__c = con.Id;
        update acc;      
        
        Opportunity opp = new Opportunity(Name='Valid Opportinity', CloseDate=Date.today(),StageName='Closed Won', 
                                          Probability=100,AccountId=acc.Id, Description='TEST DESCRIPTION');
        Opportunity nonValidOpp = new Opportunity(Name='Valid Opportinity', CloseDate=Date.today(),StageName='Closed Won', 
                                                  Probability=15,AccountId=acc.Id, Description='TEST DESCRIPTION');
        insert opp;
        insert nonValidOpp;
        
        List<COVA_Project__c> project = [SELECT Id, Name, COVA_Description__c, COVA_Opportunity__c ,COVA_PrimaryContact__c FROM COVA_Project__c ];
        System.assertEquals(1, project.size());
        System.assertEquals(opp.Name, project.get(0).Name);
        System.assertEquals(opp.Description, project.get(0).COVA_Description__c);
        System.assertEquals(opp.Id, project.get(0).COVA_Opportunity__c);
        System.assertEquals(con.Id, project.get(0).COVA_PrimaryContact__c);
        
        opp.AccountId = null;
        opp.Description = '';
        delete project;
        
        update opp;
        List<COVA_Project__c> projects = [SELECT Id, Name, COVA_Description__c, COVA_Opportunity__c ,COVA_PrimaryContact__c FROM COVA_Project__c ];
        System.assertEquals(1, projects.size());
        System.assertEquals(opp.Name, projects.get(0).Name);
        System.assertEquals(null, projects.get(0).COVA_Description__c);
        System.assertEquals(opp.Id, projects.get(0).COVA_Opportunity__c);
        System.assertEquals(null, projects.get(0).COVA_PrimaryContact__c);
        
        delete projects.get(0);
        
        opp.Probability = 79;
        update opp;
        
        List<COVA_Project__c> projectsAfterUpdateProbabil = [SELECT Id, Name, COVA_Description__c, COVA_Opportunity__c ,COVA_PrimaryContact__c FROM COVA_Project__c ];
        System.assertEquals(true, projectsAfterUpdateProbabil.isEmpty());
        opp.Probability = 81;
        update opp;
        
        List<COVA_Project__c> projectsUfterUpdate = [SELECT Id, Name, COVA_Description__c, COVA_Opportunity__c ,COVA_PrimaryContact__c FROM COVA_Project__c ];
        System.assertEquals(1, projectsUfterUpdate.size());
        System.assertEquals(null, projectsUfterUpdate.get(0).COVA_Description__c);
        System.assertEquals(opp.Id, projectsUfterUpdate.get(0).COVA_Opportunity__c);
        System.assertEquals(null, projectsUfterUpdate.get(0).COVA_PrimaryContact__c);
    }  
    
    
}