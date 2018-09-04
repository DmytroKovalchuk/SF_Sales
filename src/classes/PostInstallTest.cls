@isTest
private class PostInstallTest {
    
    @isTest static void testInstall() {
        PostInstall install = new PostInstall();
        install.pluginVersion = 1;

        Test.testInstall(install, null);

        //check custom setting
        System.assertNotEquals(null, DPS_Plugin_Settings__c.getOrgDefaults().DPS_Plugin_Version__c);
    }
    
}