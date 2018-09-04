@isTest
public class COVA_TimeEntryPageControllerTest {
    
    static testMethod void execute() {
        dataPreparation();
        COVA_TimeEntryPageController controller = new COVA_TimeEntryPageController();
        List<SelectOption> expected = new List<SelectOption>{
            new SelectOption('--None--','--None--'),
                new SelectOption('Test Contact','Test Contact')
                };
                  //  System.assertEquals(expected, controller.getConsultants());         
        
        controller.tableFill();       
        System.assertEquals(true, controller.listOfWrappers.isEmpty());
        
        controller.validConsultant = 'Test Contact';
        controller.tableFill();
       // System.assertEquals(1, controller.listOfWrappers.size());
        
        //controller.wrapObjectIdToRemove = controller.listOfWrappers.get(0).projectAndTask;
        controller.deleteRow();
        System.assertEquals(0, controller.listOfWrappers.size());
        controller.sizeToShow = 2;
        controller.addRow();
        //System.assertEquals(2, controller.listOfWrappers.size());
        
        controller.tableFill();
        controller.startDate = Date.today();
        
       /* controller.listOfWrappers.get(0).spendTime = new List<COVA_Time__c>{
            new COVA_Time__c(COVA_TimeSpend__c=4),
                new COVA_Time__c(COVA_TimeSpend__c=5),
                new COVA_Time__c(COVA_TimeSpend__c=6)
                };   */                 
                    controller.save();
        List<COVA_Time__c> times = [SELECT COVA_Date__c, COVA_BillingRule__c, COVA_TimeSpend__c, COVA_Project__c, Id, COVA_Task__c FROM COVA_Time__c];
        /*System.assertEquals(3, times.size());
        System.assertEquals(Date.today(), times.get(0).COVA_Date__c);
        System.assertEquals(Date.today().addDays(1), times.get(1).COVA_Date__c);
        System.assertEquals(Date.today().addDays(2), times.get(2).COVA_Date__c);
        System.assertEquals(controller.listOfWrappers.get(0).spendTime.get(0).COVA_TimeSpend__c, times.get(0).COVA_TimeSpend__c);
        System.assertEquals(controller.listOfWrappers.get(0).spendTime.get(1).COVA_TimeSpend__c, times.get(1).COVA_TimeSpend__c);
        System.assertEquals(controller.listOfWrappers.get(0).spendTime.get(2).COVA_TimeSpend__c, times.get(2).COVA_TimeSpend__c);    */    
    }
    
    private static void dataPreparation(){
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
        
        List<COVA_Project__c>  projects = new List<COVA_Project__c>{
            new COVA_Project__c(COVA_Description__c='For test only',COVA_Opportunity__c=opp.Id,COVA_PrimaryContact__c=con.Id),
                new COVA_Project__c(COVA_Description__c='For test only',COVA_Opportunity__c=nonValidOpp.Id,COVA_PrimaryContact__c=con.Id)
                };
                    insert projects;
        
        List<COVA_BillingRule__c> rules = new List<COVA_BillingRule__c>{
            new COVA_BillingRule__c(Name='BIll-Rule1',COVA_Account__c=acc.Id,COVA_Nonbillable__c=false,COVA_Project__c=projects.get(0).Id),
                new COVA_BillingRule__c(Name='BIll-Rule2',COVA_Account__c=acc.Id,COVA_Nonbillable__c=true,COVA_Project__c=projects.get(1).Id)
                };
                    insert rules;
        
        List<COVA_Task__c> tasks = new List<COVA_Task__c>{
            new COVA_Task__c(COVA_BillingRule__c=rules.get(0).Id,COVA_Consultant__c=con.Id,COVA_Project__c=projects.get(0).Id),
                new COVA_Task__c(COVA_BillingRule__c=rules.get(1).Id,COVA_Consultant__c=con.Id,COVA_Project__c=projects.get(1).Id)
                };
                    insert tasks;
    }
}