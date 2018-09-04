public with sharing class CalculatedVisits {    
    public List<ControllerTour> wrapList{set;get;}
    
    public final ControllerTour helpObject{get;set;}
    
    public Visit__c oneVisit{get;set;} 
    
    public boolean allDuration{get;set;}
    
    public CalculatedVisits(List<ControllerTour> listVontr, ControllerTour helpob){
        wrapList = listVontr;
        helpObject = helpob;
    }
    
     public CalculatedVisits(Visit__c visitt){            
        oneVisit = visitt;       
    }    
    
    public List<ControllerTour> validList(List<ControllerTour> listV) {
        List<ControllerTour> valid = new List<ControllerTour>();
        Integer durationInsert = (helpObject.endDateTime.hour() - helpObject.startDateTime.hour())*60 + helpObject.endDateTime.minute() - helpObject.startDateTime.minute();
        if(durationInsert <= 0){
            System.assert(false,'@@@@General duration more than valid');
            return null;
        }
        Integer validDuration = 0;
        Integer taAdd = helpObject.duration + helpObject.brake;
        for(ControllerTour index: listV){
            if(index.isSelect){
                valid.add(index);
                validDuration += taAdd;
            }
        }
        if(validDuration > durationInsert){
            System.assert(false,'@@@@General duration more than valid LLLL');
            return null;
        }
        valid.sort();
        return valid;
    }
    
    public List<CalculatedVisits> result(){
        List<CalculatedVisits> visits = new List<CalculatedVisits>();  
        Integer flag = 0;
        Time starts = null;
        Time ends;
        
        for(ControllerTour control : validList(wrapList)){
            if(flag==0){ visits.add(new CalculatedVisits(new Visit__c(StartDateTime__c=datetime.newInstance(Date.today(),helpObject.startDateTime),
                                                                      EndDateTime__c=datetime.newInstance(Date.today(),Time.newInstance(helpObject.startDateTime.hour(),helpObject.duration+helpObject.startDateTime.minute(),0,0)),
                                                                      Customer__c=control.oneContact.Id,Representative__c = UserInfo.getUserId())));
                        starts = Time.newInstance(helpObject.startDateTime.hour(),helpObject.duration+helpObject.startDateTime.minute()+helpObject.brake,0,0);                       
                        flag++;
                       }
            else{
                visits.add(new CalculatedVisits(new Visit__c(StartDateTime__c=datetime.newInstance(Date.today(),starts),
                                                             EndDateTime__c=datetime.newInstance(Date.today(),Time.newInstance(starts.hour(),helpObject.duration+starts.minute(),0,0)),
                                                             Customer__c=control.oneContact.Id,Representative__c = UserInfo.getUserId())));
                starts = Time.newInstance(starts.hour(),helpObject.duration+starts.minute()+helpObject.brake,0,0);                       
                flag++;
            }       
            
        }
        
        if(visits.size() != 0 && visits != null){ return visits;}
        return null;
    }    
    
}