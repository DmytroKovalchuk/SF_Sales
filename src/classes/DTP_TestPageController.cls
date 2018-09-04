public class DTP_TestPageController {
    
    public DTP_Wrapper getTestWrapper(){
        DTP_Wrapper wrap = new DTP_Wrapper().newBuilder().setSelectedObjectName('Test').setselectedRelatedField('TestField').build();
        return wrap;// DTP_Wrapper.newBuilder.s
    }

}