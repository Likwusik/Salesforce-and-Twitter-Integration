@isTest
private class LogServiceTest {

    @isTest
    static void testLogErrorSuccessfulInsert() {

        // Check if the Log__c object is creatable to ensure the test runs only if the object is available
        if (Schema.sObjectType.Log__c.isCreateable()) {
            // Create test data
            LogService.LogDetails logDetails = new LogService.LogDetails(
                // Create test data for LogDetails
                'TestClass',
                'This is a user friendly message.',
                'This is a detailed error message.',
                'Stack trace details here.'
            );

            // Call the method to be tested
            Test.startTest();
            LogService.logError(logDetails);
            Test.stopTest();

            // Verify results
            Log__c[] logs = [SELECT Class_Name__c, User_Friendly_Message__c, Message__c, StackTrace__c FROM Log__c];
            System.assertEquals(1, logs.size(), 'One Log__c record should be created.');
            
            // Verify the details of the created Log__c record
            Log__c log = logs[0];
            System.assertEquals('TestClass', log.Class_Name__c, 'Class name does not match.');
            System.assertEquals('This is a user friendly message.', log.User_Friendly_Message__c, 'User friendly message does not match.');
            System.assertEquals('This is a detailed error message.', log.Message__c, 'Error message does not match.');
            System.assertEquals('Stack trace details here.', log.StackTrace__c, 'Stack trace does not match.');
        } else {
            System.debug('Log__c object is not createable.');
        }
    }
    
}