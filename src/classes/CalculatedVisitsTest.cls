@isTest
public class CalculatedVisitsTest {
    
    @isTest
    static void validListCorrectTest(){
        ControllerTour helpObjCorrect = new ControllerTour(Time.newInstance(1, 1, 1, 1),Time.newInstance(7, 2, 2, 2),15,15);
        List<ControllerTour> testList = new List<ControllerTour>{new ControllerTour(new Contact(FirstName='Con1',LastName='Kov1'),6,true),
                                                                 new ControllerTour(new Contact(FirstName='Con2',LastName='Kov2'),1,true),
                                                                 new ControllerTour(new Contact(FirstName='Con1',LastName='Kov3'),3,true)};
         
         CalculatedVisits calcObject = new CalculatedVisits(testList,helpObjCorrect);
        List<ControllerTour> valid = new List<ControllerTour>();
        valid = calcObject.validList(testList);
        List<ControllerTour> checkList = new List<ControllerTour>{new ControllerTour(new Contact(FirstName='Con2',LastName='Kov2'),1,true),
                                                                 new ControllerTour(new Contact(FirstName='Con3',LastName='Kov3'),3,true),
                                                                 new ControllerTour(new Contact(FirstName='Con1',LastName='Kov1'),6,true)};
        System.debug('VVVVVVV' +  valid);
        System.assertEquals(checkList, valid,'Invalid Lists');
                                                                   
                                                                     
    }
}