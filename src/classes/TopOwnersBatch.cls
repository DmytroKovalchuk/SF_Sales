global class TopOwnersBatch implements Database.Batchable<sObject>, schedulable {
      
    global void TopOwnersBatch() {
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([SELECT Id, Name FROM User WHERE isActive = true and Id IN (SELECT OwnerId FROM Opportunity WHERE StageName = 'Closed Won')]);
    }

    public static void execute(SchedulableContext sc){
        TopOwnersBatch batchable = new TopOwnersBatch();
        Database.executeBatch(batchable);
    }

    global void execute(Database.BatchableContext bc, List<User> users) {
        Integer FiscalYearStartMonth = [select FiscalYearStartMonth from Organization where id=:Userinfo.getOrganizationId()].FiscalYearStartMonth;
        Date fiscalYearStartDate;
        Integer quarter;

        if(system.today().month() >= FiscalYearStartMonth)
        {
            fiscalYearStartDate = date.newinstance(system.today().year(), FiscalYearStartMonth, 1);
            quarter = ((system.today().month() - FiscalYearStartMonth) / 3) + 1;
        }
        else
        {
            fiscalYearStartDate = date.newinstance(system.today().year() - 1, FiscalYearStartMonth, 1);
            quarter = ((12 + system.today().month() - FiscalYearStartMonth) / 3) + 1;
        }    

        Integer addMonths = quarter * 3;

        Date lastDateOfThisQuarter = fiscalYearStartDate;

        // this is the last date of the current quarter
        Date fiscalYearEndDate = fiscalYearStartDate.addMonths(12).addDays(-1);
        Date PrevfiscalYearStartDate = fiscalYearStartDate.addMonths(-12);
        Date PrevfiscalYearEndDate = fiscalYearEndDate.addMonths(-12);
        lastDateOfThisQuarter = lastDateOfThisQuarter.addMonths(addMonths).addDays(-1);
        Date firstDateOfThisQuarter = lastDateOfThisQuarter.addMonths(-3).addDays(1);
        Date firstDateOfLastQuarter = lastDateOfThisQuarter.addMonths(-6).addDays(1);
        Date lastDateOfLastQuarter = lastDateOfThisQuarter.addMonths(-3);
        system.debug('Fiscal Year Start Date: '+ fiscalYearStartDate);
        system.debug('Fiscal Year End Date: '+fiscalYearEndDate);
        system.debug('Previous FY Start Date: '+PrevfiscalYearStartDate);
        system.debug('Previous FY End Date: '+PrevfiscalYearEndDate);
        system.debug('Last Date of this Quarter: '+ lastDateofThisQuarter);
        system.debug('First Date of This Quarter: '+ firstDateOfThisQuarter);
        system.debug('First date of last quarter: '+ firstDateOfLastQuarter);
        system.debug('Last date of last quarter: '+ lastDateOfLastQuarter);
        Set<Id> userIds = new Set<Id>();
        Map<Id, UserOpp> userOppMap = new Map<Id, UserOpp>();
        Decimal totalAmount = 0;        
        List<UserOpp> userOppList = new List<UserOpp>();
   
        for(User user : users){
            userIds.add(user.Id);
            userOppMap.put(user.Id, new UserOpp(user.Id, user.Name));
        }
        totalAmount = 0;
        
        String timeframe = DPS__c.getOrgDefaults().Time_Period__c;
        System.debug('Time Frame = '+timeframe);
        Date date1 = system.today();
        Date date2 = system.today();
        If(timeframe=='Current FQ'){
            date1=firstDateOfThisQuarter;
            date2=lastDateofThisQuarter;
        }else if(timeframe=='Previous FQ'){
            date1=firstDateofLastQuarter;
            date2=lastDateOfLastQuarter;
        }else if(timeframe=='Current FY'){
            date1=fiscalYearStartDate;
            date2=fiscalYearEndDate;
        }else if(timeframe=='Previous FY'){
            date1=PrevfiscalYearStartDate;
            date2=PrevfiscalYearEndDate;
        }
        String stagename = 'Closed Won';
        system.debug(timeframe);
        for(Opportunity opp : [SELECT Id, OwnerId, StageName, Amount FROM Opportunity WHERE OwnerId in :userIds AND Amount > 0 and StageName = :stagename AND CloseDate >= :date1 AND CloseDate <= :date2]){
                userOppMap.get(opp.OwnerId).incrementAmount(opp.Amount);
                totalAmount += opp.Amount;
        }
        system.debug('Total amount = ' + totalAmount);
        userOppList.addAll(userOppMap.values());

        System.debug('Total amount = ' + totalAmount);
        System.debug('DPS = ' + DPS__c.getOrgDefaults());
        System.debug('Top percent = ' + DPS__c.getOrgDefaults().Top_Percent__c);

        Decimal percentAmount = totalAmount * ((DPS__c.getOrgDefaults().Top_Percent__c) / 100);
        String topOwners = '';
        list<folioEvent__c> contentEvents = new list<folioEvent__c>();
        if(userOppList != null && userOppList.size() > 0){
            userOppList.sort();

            if(userOppList.get(0).amount > percentAmount){
                topOwners = userOppList.get(0).userId;
            
                if(userOppList.size() > 1){
                    for(Integer i = 1; i < userOppList.size(); i++){
                        if(userOppList.get(i).amount > percentAmount){
                            topOwners += ',' + userOppList.get(i).userId;
                        } else {
                            break;
                        }
                    }
                }
                
                
            }
        }
        DPS__c dpsSettings = DPS__c.getOrgDefaults();
        dpsSettings.Top_Salespeople__c = topOwners;
        upsert dpsSettings;

        //Get content folioEvents
        contentEvents = [select id,Top_Salesperson__c,OwnerId from folioEvent__c where eventName__c = 'Content View'];
        //If Top, check flag, otherwise, uncheck flag
        for (folioEvent__c f : contentEvents){
            if(topOwners.contains(f.OwnerId))
                f.Top_Salesperson__c = true;
            else
                f.Top_Salesperson__c = false;
        }

        update contentEvents;
    }
    
    global void finish(Database.BatchableContext BC) {

    }


    
    public class UserOpp implements comparable{
        Id userId;
        String userName;
        Decimal amount;

        public UserOpp(Id userId, String userName){
            this.userId = userId;
            this.userName = userName;
            this.amount = 0;
        }

        public void incrementAmount(Decimal amount){
            this.amount += amount;
        }

        public Integer compareTo(Object compareTo) {
            UserOpp compareObj = (UserOpp)compareTo;
            if(this.amount == compareObj.amount){
                return 0;
            } else if(this.amount > compareObj.amount) {
                return -1;
            } else {
                return 1;
            }
        }

    }
}