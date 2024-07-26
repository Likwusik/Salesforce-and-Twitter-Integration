@isTest
public class TwitterIntegrationControllerTest {

    @isTest
    static void testPostTweetSuccess() {
        // Set the mock response for a successful POST request
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerators('POST', 201, '{"data": {"id": "12345", "text": "Hello Twitter!"}}'));

        // Perform the test
        Test.startTest();
        TwitterIntegrationController.TweetResponse response = TwitterIntegrationController.postTweet('Hello Twitter!');
        Test.stopTest();
        
        // Assert the expected response
        System.assertEquals('12345', response.id, 'The tweet ID should be 12345');
        System.assertEquals('Hello Twitter!', response.text, 'The tweet text should be "Hello Twitter!"');
    }

    @isTest
    static void testPostTweetError() {
        // Set the mock response for a failed POST request
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerators('POST', 400, 'Error posting tweet'));

        // Perform the test and expect an exception
        Test.startTest();
        try {
            TwitterIntegrationController.postTweet('Hello Twitter!');
            System.assert(false, 'Expected a CalloutException to be thrown');
        } catch (CalloutException e) {
            // Expected exception
            System.assert(e.getMessage().contains('Error posting tweet'), 'Exception message should indicate a posting error');
        }
        Test.stopTest();
    }

    @isTest
    static void testDeleteTweetSuccess() {
        // Set the mock response for a successful DELETE request
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerators('DELETE', 200, '{}'));

        // Perform the test
        Test.startTest();
        TwitterIntegrationController.deleteTweet('12345');
        Test.stopTest();
        
        // No assertion is needed here, but you can add checks to ensure no exceptions were thrown
    }

    @isTest
    static void testDeleteTweetError() {
        // Set the mock response for a failed DELETE request
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerators('DELETE', 400, 'Error deleting tweet'));

        // Perform the test and expect an exception
        Test.startTest();
        try {
            TwitterIntegrationController.deleteTweet('12345');
            System.assert(false, 'Expected a CalloutException to be thrown');
        } catch (CalloutException e) {
            // Expected exception
            System.assert(e.getMessage().contains('Error deleting tweet'), 'Exception message should indicate a deleting error');
        }
        Test.stopTest();
    }
}