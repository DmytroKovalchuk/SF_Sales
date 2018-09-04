public virtual class DTP_Wrapper {

    public String selectedObjectName { get; set; }
    public String selectedRelatedField { get; set; }
    public Boolean isAvailable { get; set; }
    
    public DTP_WraperBuilder newBuilder(){
        return new DTP_WraperBuilder();
    }
  
}