public with sharing class COVA_AccountTaskApexController {
    
    @AuraEnabled
    public static List<Account> getAccount(){
        List<Account> accountList = [SELECT Id, Name FROM Account WHERE OwnerId =:UserInfo.getUserId() ];//AND Name = 'KOVAL'];s        
        return accountList;
    }
    
    @AuraEnabled
    public static List<COVA_AccountTask__c> getAccountTasks(String accountId){
        System.debug('accountId = = =' + accountId);
        List<COVA_AccountTask__c> taskList = [SELECT Id, Name, COVA_TaskDescription__c FROM COVA_AccountTask__c
                                        WHERE COVA_Account__c =: accountId AND COVA_IsNotToShow__c = false];
        System.debug('taskList==' + taskList.size());
        return taskList;
    }
}