@isTest
private class SetupControllerTest {
    
    @isTest static void testSetupController() {
        DPS__c dpsSettings = DPS__c.getOrgDefaults();
        dpsSettings.Time_Out__c = 30;
        dpsSettings.App_Url__c = '//v1/slot/';
        upsert dpsSettings;

        setupController controller = new SetupController();
        controller.init();
        controller.save();
        controller.selectClick();
        controller.unselectClick();
        controller.getSelectedValues();
        controller.getUnselectedValues();

        controller.upload();

        System.assertEquals('30', controller.eventTimeout);
    }
    
}