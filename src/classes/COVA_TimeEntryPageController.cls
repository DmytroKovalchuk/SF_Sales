public class COVA_TimeEntryPageController {
    
    private ApexPages.StandardSetController standartControllers { get; set; }
    public Integer sizeToShow { get;set; }   
    
    public static final String NONE = Label.COVA_None;
    public static final Integer DAYS_OF_WEEK = 7;
    
    public Date startDate { get; set;}   
    public String wrapObjectIdToRemove { get; set; }  
    
    public List<Wrapper> addRowListOfWrappers { get; set; }
    public List<Wrapper> listOfWrappers { get; set; }
    
    public String validConsultant { get; set; }
    public COVA_TimeEntryPageController () {
        startDate = Date.today();
        sizeToShow = 0;
    }
    
    public class Wrapper {    
        public String projectAndTask { get; set; }
        public List<COVA_Time__c> spendTime { get; set;}
        public Boolean isBilliable { get; set; }
        public COVA_Task__c validTaskReference{ get; set; }
        
    }
    
    public List<SelectOption> getConsultants () {        
        List<SelectOption> validContacts = new List<SelectOption>();
        validContacts.add(new SelectOption(NONE,NONE));
        Map<Id,COVA_Task__c> mapOfContacts = new Map<Id,COVA_Task__c>();
        for(COVA_Task__c mapIndex : [SELECT Id, COVA_Consultant__r.Name, COVA_Consultant__c, COVA_Project__r.Name FROM COVA_Task__c]){
            mapOfContacts.put(mapIndex.COVA_Consultant__c, mapIndex);
        }            
        for(COVA_Task__c index : mapOfContacts.values()){            
            validContacts.add(new SelectOption(index.COVA_Consultant__c,String.valueOf(index.COVA_Consultant__r.Name)));
        }        
        return validContacts;
    }
    
    public void tableFill(){
        if(sizeToShow == 0){
            sizeToShow = 1;
        }         
        listOfWrappers = new List<Wrapper>();  
        if(isNotNone()){ 
            List<COVA_Task__c> validTasks;             
            String queryString = 'SELECT Name, COVA_Project__c, COVA_Project__r.Name, COVA_BillingRule__c, COVA_BillingRule__r.COVA_Active__c,' +
                + 'COVA_Consultant__c, COVA_Consultant__r.Name FROM COVA_Task__c WHERE COVA_Consultant__c =: validConsultant';
            standartControllers = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
            standartControllers.setPageSize(sizeToShow);
            validTasks = standartControllers.getRecords();
            if(validTasks != null && validTasks.size() > 0){ 
                for(COVA_Task__c selectTask : validTasks){
                    getPrefillWrapper(selectTask);
                }
            }
        }    
    }
    
    private Boolean isNotNone(){
        return (validConsultant != null && !validConsultant.equals(NONE));
    }
    
    private void getPrefillWrapper(COVA_Task__c task){
        Wrapper wrapp = new Wrapper();
        wrapp.validTaskReference = task;
        wrapp.projectAndTask = task.COVA_Project__r.Name + ' - '  + task.Name;
        wrapp.spendTime = new List<COVA_Time__c>();  //should be clarified
        //[SELECT COVA_TimeSpend__c, Id, COVA_Date__c FROM COVA_Time__c WHERE COVA_Task__c IN :standartControllers.getRecords() 
        //AND COVA_Date__c > :startDate AND COVA_Date__c < :startDate.addDays(7)];        
        for(Integer i = 0; i < DAYS_OF_WEEK; i++){
            wrapp.spendTime.add(new COVA_Time__c(COVA_TimeSpend__c=0));
        }
        listOfWrappers.add(wrapp);
    }
    
    public void save () {        
        List<COVA_Time__c> timesToInsert = new List<COVA_Time__c>();
        
        Map<Id, Boolean> mapOfBillingRulesToUpdate = new Map<Id, Boolean>();
        List<COVA_BillingRule__c> rulesToUpdate = new List<COVA_BillingRule__c>();
        
        if(isWrapperListNotNull()){
            for(Wrapper wrap : listOfWrappers){
                mapOfBillingRulesToUpdate.put(wrap.validTaskReference.COVA_BillingRule__c, wrap.isBilliable);                
                Date beginDate = this.startDate;
                for(COVA_Time__c selTime : wrap.spendTime){
                    if(selTime.COVA_TimeSpend__c > 0 ){
                        selTime.COVA_Date__c = beginDate;
                        selTime.COVA_BillingRule__c = wrap.validTaskReference.COVA_BillingRule__c;
                        selTime.COVA_Project__c = wrap.validTaskReference.COVA_Project__c;
                        selTime.COVA_Task__c = wrap.validTaskReference.Id;                    
                        timesToInsert.add(selTime);
                        beginDate = beginDate.addDays(1);
                    }
                    else {
                        beginDate = beginDate.addDays(1);
                    }
                }
            }
        }
        
        for(COVA_BillingRule__c rule : [SELECT Id, COVA_Active__c FROM COVA_BillingRule__c WHERE Id IN :mapOfBillingRulesToUpdate.keySet()]){
            rule.COVA_Nonbillable__c = mapOfBillingRulesToUpdate.get(rule.Id);
            rulesToUpdate.add(rule);            
        }
        try{            
            insert timesToInsert;
            update rulesToUpdate;
        }
        catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,e.getStackTraceString());
            ApexPages.addMessage(myMsg);
        }        
    }
    
    private Boolean isWrapperListNotNull(){
        return (listOfWrappers != null && listOfWrappers.size() > 0);
    }
    
    public void addRow() {       
        if(listOfWrappers == null){
            return;
        }      
        if(sizeToShow > listOfWrappers.size()){
            tableFill();
            sizeToShow--;
        }
        sizeToShow ++;
        tableFill();    
    }
    
    public void deleteRow(){          
        List<Wrapper> afterDelete = new List<Wrapper>();
        addRowListOfWrappers = listOfWrappers;
        for(Wrapper wrap : listOfWrappers){   
            if(!String.valueOf(wrap.projectAndTask).equals(wrapObjectIdToRemove)){               
                afterDelete.add(wrap);               
            }
        }       
        this.listOfWrappers = afterDelete;
        if(sizeToShow > 0){
            sizeToShow--;
        }        
    }
    
    public void createTrigger(){
        new COVA_MetadataExampleFirst().createApexClass();
    }
    
}