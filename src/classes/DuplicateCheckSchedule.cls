global class DuplicateCheckSchedule implements schedulable {
 global void execute(SchedulableContext sc){        
       DuplicateSearch updater = new DuplicateSearch('select Id from Visit__c where Status__c=="In Progress"  ', 'Visit__c', 'Status__c', 'Closed');
        Id batchInstanceId = Database.executeBatch(updater);
        
    }
}