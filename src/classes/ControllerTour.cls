public class ControllerTour implements Comparable {
    
    public List<Contact> contacts{get;set;}    
    public List<ControllerTour> controllerList{get;set;}     
    
    public List<CalculatedVisits> toShowVisits{get;set;}
    
    public boolean isSelect{get;set;}    
    public Integer order{get;set;}
    public Contact oneContact{get;set;}    
    
    public Time startDateTime{get;set;}
    public Time endDateTime{get;set;}
    public Integer duration{get;set;}
    public Integer brake{get;set;}
    
    public Integer size{get;set;}
    
    public ControllerTour(){        
        if(controllerList == null){ controllerList = new List<ControllerTour>();                        
        contacts = [SELECT Name FROM Contact WHERE Is_Target__c = true/*Id in (SELECT Customer__c FROM Target__c WHERE Representative__c =:UserInfo.getUserId())*/];    
        Integer ord = 1;
        for(Contact index: contacts){            
            controllerList.add(new ControllerTour(index,ord,isSelect));
            ord++;            
        }
        size = controllerList.size();
        startDateTime = Time.newInstance(9,0, 0, 0);
        endDateTime = Time.newInstance(18, 0, 0, 0);
        duration = 15;
        brake = 20; 
            }
        
    }
    
    public ControllerTour(Contact oneCont, Integer inorder, Boolean isSelec){
        oneContact = oneCont;
        order = inorder;
        isSelect = isSelec;       
    }
    
    public ControllerTour(Time start, Time endDate, Integer durations, Integer brakes){
        startDateTime = start;
        endDateTime = endDate;
        duration = durations;
        brake = brakes;
    }
    
    public PageReference calculate(){       
        CalculatedVisits calculated = new CalculatedVisits(controllerList, new ControllerTour(startDateTime, endDateTime, duration, brake));
        toShowVisits = calculated.result();
         controllerList.sort();
        return null;
    }
    
    public PageReference save(){
        List<Visit__c> toInsertVisits = new List<Visit__c>();
        for(CalculatedVisits visit :  toShowVisits){
            toInsertVisits.add(visit.oneVisit);
        }
        try{
            System.Database.insert(toInsertVisits);
        }
        catch(Exception e){
            System.debug('@@@@@Exception during insert visits' + e);
        }
        return null;
    } 
    
    public Integer compareTo(Object contr){       
        ControllerTour comp = (ControllerTour)(contr); 
        
        if (this.order > comp.order) {
            return 1;
        }
        
        if (this.order == comp.order) {
            return 0;
        }
        
        return -1;
    }
    //do not use
    public void selectAll(){
        for(ControllerTour index: controllerList){
            if(index.isSelect == false){index.isSelect = true;}
            else index.isSelect = false; 
        }
    }
    
    public void sendEmail(){
        System.debug('URL Host ==== ' + System.Url.getSalesforceBaseUrl().toExternalForm());
       //  System.debug('URL Path ==== ' + Url.getPath();
        // System.debug('URL Protocol ==== ' + Url.getProtocol();
    }
    
}