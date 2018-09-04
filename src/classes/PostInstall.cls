global without sharing class PostInstall implements InstallHandler {
    
    //Modify this variable to be the DPS plugin version number
    public Integer pluginVersion = System.requestVersion().major();

    global void onInstall(InstallContext context){
        if(context.previousVersion() == null) {

            DPS__c appSettings = DPS__c.getOrgDefaults();
            appSettings.Time_Out__c = 30;
            appSettings.Top_Percent__c = 10;
            appSettings.Time_Period__c = 'Current FY';
            appSettings.Folio_Conversion__c = false;
            /*for(Document d : [Select id,name,NamespacePrefix from Document where Type='png']){
                system.debug(d.name +':'+ d.NamespacePrefix);
                appSettings.DPS_Logo__c = d.Id;
            }*/
            appSettings.App_Url__c = 'mysfdc://v1/slot/library';
            upsert appSettings;   

            List<DPS_Event__c> eventList = new List<DPS_Event__c>();
            eventList.add(new DPS_Event__c(Name = 'App Close', Event_Selected__c = false));
            eventList.add(new DPS_Event__c(Name = 'App Startup', Event_Selected__c = false));
            eventList.add(new DPS_Event__c(Name = 'Contet Browse', Event_Selected__c = false));
            eventList.add(new DPS_Event__c(Name = 'Content Exit', Event_Selected__c = false));
            eventList.add(new DPS_Event__c(Name = 'Content View', Event_Selected__c = true));
            eventList.add(new DPS_Event__c(Name = 'End of article reached', Event_Selected__c = false));
            eventList.add(new DPS_Event__c(Name = 'Issue Download Started', Event_Selected__c = false));
            eventList.add(new DPS_Event__c(Name = 'Overlay Started', Event_Selected__c = false));
            eventList.add(new DPS_Event__c(Name = 'Overlay Stopped', Event_Selected__c = false));
            upsert eventList;
        
            try{
                System.Schedule('Update Top SalesPeople :30', '0 30 * * * ?', new TopOwnersBatch());
       
            }catch(exception ex){
       
            }
        }
        
        DPS_Plugin_Settings__c pluginSettings = DPS_Plugin_Settings__c.getOrgDefaults();
        pluginSettings.DPS_Plugin_Version__c = String.valueOf(pluginVersion);

        upsert pluginSettings;
    }

}