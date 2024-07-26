@isTest
public class Twitter0Auth1Test {

    @isTest
    static void testGetAuthorizationHeader() {
        // Define expected values to test against
        String expectedConsumerKey = 'testConsumerKey';
        String expectedConsumerSecret = 'testConsumerSecret';
        String expectedAccessToken = 'testAccessToken';
        String expectedAccessTokenSecret = 'testAccessTokenSecret';
        
        // Call the method to test
        Test.startTest();
        String httpMethod = 'GET';
        String endpoint = 'https://api.twitter.com/1.1/statuses/home_timeline.json';
        String authHeader = Twitter0Auth1.getAuthorizationHeader(httpMethod, endpoint);
        Test.stopTest();

        // Debug output
        System.debug('Authorization Header: ' + authHeader);

        // Assertions
        System.assert(authHeader.startsWith('OAuth '), 'The header should start with "OAuth "');
        
        Boolean hasSignature = authHeader.contains('oauth_signature="');
        System.assert(hasSignature, 'The header should contain the signature');
    }
}