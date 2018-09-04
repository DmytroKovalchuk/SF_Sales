global with sharing class SetupController {

    public List<string> leftselected{get;set;}
    public List<string> rightselected{get;set;}
    Set<string> leftValues = new Set<string>();
    Set<string> rightValues = new Set<string>();

    public String imageURL{get;set;}
    public String eventTimeout{get;set;}
    public String timePeriod{get;set;}
    public String deepLinkUrl{get;set;}
    public Boolean folioConversion{get;set;}
    public Decimal topPercent{get;set;}

    public void init(){
        leftselected = new List<String>();
        rightselected = new List<String>();
        
        for(DPS_Event__c event : DPS_Event__c.getAll().values()){
            if(event.Event_Selected__c == true){
                rightValues.add(event.Name);
            } else {
                leftValues.add(event.Name);
            }
        }

        DPS__c dpsSettings = DPS__c.getOrgDefaults();
        deepLinkUrl = dpsSettings.App_Url__c;
        eventTimeout = String.valueOf(dpsSettings.Time_Out__c);
        timePeriod = dpsSettings.Time_Period__c;
        folioConversion = dpsSettings.Folio_Conversion__c;
        topPercent = dpsSettings.Top_Percent__c;

        imageURL = '/servlet/servlet.FileDownload?file=' + DPS__c.getOrgDefaults().DPS_Logo__c;
        System.debug('Image Url = ' + imageURL);
    }

    public void save(){
        If(!deepLinkUrl.contains('//v1/slot/')){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'App URL must contain //v1/slot/'));
            return;
            }
                       
        Map<String, DPS_Event__c> eventSettings = DPS_Event__c.getAll();
              
        for(String eventName : rightValues){
            eventSettings.get(eventName).Event_Selected__c = true;
        }

        for(String eventName : leftValues){
            eventSettings.get(eventName).Event_Selected__c = false;
        }

        update eventSettings.values();

        Integer timeOut = 30;
        if(eventTimeout != null && eventTimeout.isNumeric()){
            timeOut = Integer.valueOf(eventTimeout);
        }
            

        DPS__c dpsSettings = DPS__c.getOrgDefaults();
        dpsSettings.App_Url__c = deepLinkUrl;
        dpsSettings.Time_Out__c = timeOut;
        dpsSettings.Top_Percent__c = topPercent;
        dpsSettings.Time_Period__c = timePeriod;
        dpsSettings.Folio_Conversion__c = folioConversion;
        upsert dpsSettings;

        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Saved Successfully'));
    }

    public PageReference selectclick(){
        rightselected.clear();
        for(String s : leftselected){
            leftvalues.remove(s);
            rightvalues.add(s);
        }
        return null;
    }
     
    public PageReference unselectclick(){
        leftselected.clear();
        for(String s : rightselected){
            rightvalues.remove(s);
            leftvalues.add(s);
        }
        return null;
    }
 
    public List<SelectOption> getunSelectedValues(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(leftvalues);
        tempList.sort();
        for(string s : tempList)
            options.add(new SelectOption(s,s));
        return options;
    }
 
    public List<SelectOption> getSelectedValues(){
        List<SelectOption> options1 = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(rightvalues);
        tempList.sort();
        for(String s : tempList)
            options1.add(new SelectOption(s,s));
        return options1;
    }
    
    public Document document {
        get {
          if (document == null)
            document = new Document();
          return document;
        }
        set;
    }

    public PageReference upload() {

        document.AuthorId = UserInfo.getUserId();
        document.FolderId = [SELECT Id FROM Folder WHERE Name = 'Public Images' LIMIT 1].Id;
        //document.FolderId = UserInfo.getUserId(); // put it in running user's folder
     
        try {
            insert document;
            //update custom setting
            DPS__c dpsSettings = DPS__c.getOrgDefaults();
            dpsSettings.DPS_Logo__c = document.Id;
            upsert dpsSettings;

            imageURL = '/servlet/servlet.FileDownload?file=' + document.Id;
        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
            System.debug('@@@@ Error = ' + e);
            return null;
        } finally {
            document.body = null; // clears the viewstate
            document = new Document();
        }
     
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
        return null;
    }
}