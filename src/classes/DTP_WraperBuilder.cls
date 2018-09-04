public class DTP_WraperBuilder extends DTP_Wrapper{
    
    public String selectedObjectName = '';
    public String selectedRelatedField = '';
    public Boolean isAvailable = false;
      
    public DTP_WraperBuilder setSelectedObjectName(String selectedObjectName){
        this.selectedObjectName = selectedObjectName;
        return this;
    }  
    
    public DTP_WraperBuilder setselectedRelatedField(String selectedRelatedField){
        this.selectedRelatedField = selectedRelatedField;
        return this;
    } 
    
    public DTP_WraperBuilder setisAvailable(Boolean isAvailable){
        this.isAvailable = isAvailable;
        return this;
    }
    
    public DTP_Wrapper build(){
        DTP_Wrapper wrapper = new DTP_Wrapper();
        wrapper.isAvailable = this.isAvailable;
        wrapper.selectedObjectName = this.selectedObjectName;
        wrapper.selectedRelatedField = this.selectedRelatedField;
        return wrapper;
    }
}