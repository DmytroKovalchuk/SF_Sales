@RestResource(urlMapping='/testmock/*')
global class RESTSERVICEMOCK {
    
    @HttpPost
    global static void executePost(){
         RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        Contact con = new Contact(LastName = 'Kapez123');
        
        Database.SaveResult createdContact = Database.insert(con,false); 
        Contact example = [SELECt Id, CreatedDate, LastName from Contact where id =: createdContact.Id];
        
       /* JSONGenerator generator = JSON.createGenerator(true); 
        generator.writeStartObject();
        
        generator.writeNumberField('Status' , 1.00);
        generator.writeStringField('RepRef', example.Id);
        generator.writeDateTimeField('DateTime', example.CreatedDate);
        
        generator.writeEndObject();*/
        
        res.responseBody = Blob.valueOf('{ "Status" : 1, "RepRef" : "' + example.Id + '", "DateTime" : "' + example.CreatedDate + '" }' );

         
        Blob val = req.requestBody;       
System.debug('11111111');
        System.debug('INSIDE POST ++= ' + val.toString());

       
    }

}