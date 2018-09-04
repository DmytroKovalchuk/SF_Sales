global class UpdateAccountScheduler implements Schedulable {
    global void execute(SchedulableContext sc){       
        StatusUpdater updater = new StatusUpdater('select Id from Visit__c where Status__c=\'In Progress\' ', 'Visit__c', 'Status__c', 'Closed');
        Id batchInstanceId = Database.executeBatch(updater);
        
    }
}