public class TourPlanning {
   public Account account = new Account();
    
    public List<Target__c> getContacts() {
        return [SELECT Customer__c FROM Target__c WHERE Representative__c = :account.Id];
    }
    
    public void setAccount(){
        this.account = [SELECT Id, Name, Site FROM Account 
                   WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
    }
}