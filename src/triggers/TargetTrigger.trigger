//***apex trigger to record Users id in Targets__c field in Contact***//
trigger TargetTrigger on Target__c (after insert, after delete, after update) {
    private  TargetTrigetSchedule getObject = new TargetTrigetSchedule();
    
    if(Trigger.isInsert){        
        Target__c [] targets = Trigger.new;    
        getObject.executeInsert(targets);      
    }   
    
    else if(Trigger.isDelete){  
        Target__c[] targets = Trigger.old;
        getObject.executeDelete(targets);         
    }
    
    else if(Trigger.isUpdate && Trigger.isAfter){        
        Target__c [] targetsOld = Trigger.old;
        Target__c [] targetsNew = Trigger.new;    
        getObject.executeUpdate(targetsOld,targetsNew);            
    }
    
    
}