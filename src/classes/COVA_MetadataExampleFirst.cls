public with sharing class COVA_MetadataExampleFirst {   
    
    public void createApexClass()
    {
        String endpoint = 'https://demirov-dev-ed.my.salesforce.com/services/data/v28.0/tooling/sobjects';
        //https://demirov-dev-ed.my.salesforce.com
        
        //System.debug(endpoint);
        // create a Http request with post method
        SalesforceTool tool = new SalesforceTool();
        HttpRequest req = tool.createHttpRequest(endpoint+'/ApexTrigger','POST');
        req.setBody('{ "Name" : "TestTriggerAccountMetaServiceeee", \"TableEnumOrId" : "Account",\"Body" : "trigger TestTriggerAccountMetaServiceeee on Account (after insert){ MetadataHandler.execute(Trigger.new);}" }');
        // send request and receive response
        String response = tool.getResponse(req);
        System.debug(response);
        // These two lines have no role in creating apex class. So they can be ignored for now.
//        Map<String,Object> rmp = (Map<String,Object>)JSON.deserializeuntyped(response);
//        tool.oid = (String)rmp.get('id');
//        System.debug(tool.oid);
    }
    
}