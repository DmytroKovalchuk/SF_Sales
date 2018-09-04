public class PRSD_TestInvestigateController {    
    
    public String htmlValue { get; set; }
    
    public PRSD_TestInvestigateController(){
       selectReference();
         }
    
    public void selectReference(){        
        //EmailTemplate candidate = [SELECT Id, HtmlValue FROM EmailTemplate WHERE Id = '00X0Y000000sKNV']; 
        //htmlValue = candidate.HtmlValue;
        PRSD_TemplateStorage__c templ = [SELECT Id, PRSD_PreviewHtml__c FROM PRSD_TemplateStorage__c WHERE Name = 'Template1'];
        htmlValue = templ.PRSD_PreviewHtml__c;        
    }
    
    

}