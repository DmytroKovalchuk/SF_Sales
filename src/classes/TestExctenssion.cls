public class TestExctenssion {

    public TestExctenssion(ApexPages.StandardController controller){
        System.debug('' + ApexPages.currentPage().getParameters().get('Sasha'));
    }
}