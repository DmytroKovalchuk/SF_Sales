@RestResource(urlMapping='/account/')
global with sharing  class RestClass {
    
    @HttpGet
    global static Account doGet(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        System.debug('EEEEEEEEE' + accountId);
        Account retAcc = [SELECT Id, Name, Phone, Website FROM Account WHERE id =:accountId ];     
        return retAcc;
    }
}