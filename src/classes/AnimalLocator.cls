public class AnimalLocator {
    
    public AnimalLocator(){}
    
    public static String getAnimalNameById(Integer idIn){
        Http htp = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/' + idIn);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setMethod('GET');       
        HttpResponse response = htp.send(request);
        System.debug('rrrrr' + response.getBody());       
        
        if(response.getStatusCode() != 200){
            System.debug('ERRRRR' + response.getStatus());
            return null;
        }        
       
       
        return response.getBody();
    }
    
}