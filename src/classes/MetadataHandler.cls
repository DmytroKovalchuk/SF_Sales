public with sharing class MetadataHandler {

    public static void execute(List<SObject> sobjects){
        System.debug(sobjects);
        for(SObject ttt : sobjects){
            System.debug('It is working!!!!' + ttt.Id.getSobjectType());
        }
    }
}