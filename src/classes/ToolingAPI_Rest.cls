public class ToolingAPI_Rest{

public String triggerName = 'Test Trigger';
public String baseUrl = 'https://demirov-dev-ed.my.salesforce.com';
 
private Http worker { 
    get { 
        if ( worker == null ) { 
            return new Http();
        }
        return worker; 
    } set; 
}
 
public void createApexTrigger()
{ 
    // build new request 
    HttpRequest request = new HttpRequest(); 
 
    // set headers
    request.setHeader('Authorization', 'Bearer '+ UserInfo.getSessionId());
    request.setHeader('Content-Type', 'application/json');
 
    // set request info
    request.setEndpoint(baseUrl + '/sobjects/ApexTrigger');
    request.setMethod('POST');
 
    String bodyAsJSON = '{ "Name": "'+this.triggerName+'", '
                         +'"TableEnumOrId" : "Account", ' 
                         +'"Body": "'+this.getTriggerBody()+'" }'; 
 
    request.setBody( bodyAsJSON );
 
    HttpResponse response = worker.send(request);
}
    private String getTriggerBody(){
        return 'trigger COVA_TriggerTestToolingApi on Account (after insert, after update) {}';
    }
}