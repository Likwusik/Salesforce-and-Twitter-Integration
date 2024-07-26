@IsTest
private class CreateTweetControllerTest {

    @IsTest
    static void testCreateTweetSuccess() {
        // Mock the TwitterIntegrationController
        TwitterIntegrationController.TweetResponse mockResponse = new TwitterIntegrationController.TweetResponse();
        mockResponse.id = '12345';
        
        Test.setMock(HttpCalloutMock.class, new TwitterIntegrationMock(mockResponse));

        // Create a unique tweet title to avoid unique constraint violations
        String uniqueTweetTitle = 'Test Title';

        // Call the method
        Test.startTest();
        try {
            CreateTweetController.createTweet(uniqueTweetTitle, 'This is a valid tweet text.');
        } catch (AuraHandledException e) {
            System.debug('Exception Message: ' + e.getMessage());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e; // Re-throwing to let the test fail if needed
        }
        Test.stopTest();
        
        // Verify the tweet was inserted
        Tweet__c[] tweets = [SELECT Id, Tweet_Title__c, Tweet_Text__c FROM Tweet__c];
        System.debug('Number of tweets found: ' + tweets.size());
        System.assertEquals(1, tweets.size(), 'Expected 1 tweet to be inserted.');
        System.assertEquals(uniqueTweetTitle, tweets[0].Tweet_Title__c, 'Tweet title does not match.');
        System.assertEquals('This is a valid tweet text.', tweets[0].Tweet_Text__c, 'Tweet text does not match.');
    }

    @IsTest
    static void testCreateTweetTextTooLong() {
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            CreateTweetController.createTweet('Test Title', 'x'.repeat(281));
        } catch (AuraHandledException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        Assert.isTrue(exceptionThrown, 'Exception should have been thrown for tweet text too long.');
    }

    @IsTest
    static void testCreateTweetNullTitle() {
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            CreateTweetController.createTweet(null, 'This is a valid tweet text.');
        } catch (AuraHandledException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assert(exceptionThrown, 'Exception should have been thrown for null title.');
    }
    
    @IsTest
    static void testCreateTweetEmptyTitle() {
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            CreateTweetController.createTweet('', 'This is a valid tweet text.');
        } catch (AuraHandledException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assert(exceptionThrown, 'Exception should have been thrown for empty title.');
    }

    @IsTest
    static void testCreateTweetCalloutException() {
        // Mock the TwitterIntegrationController to throw an exception
        Test.setMock(HttpCalloutMock.class, new TwitterIntegrationMock(null, true));

        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            CreateTweetController.createTweet('Test Title', 'This is a valid tweet text.');
        } catch (AuraHandledException e) {
            exceptionThrown = true;
        }
       
        Test.stopTest();
         System.assert(exceptionThrown, 'Exception should have been thrown for callout failure.');
    }

    private class TwitterIntegrationMock implements HttpCalloutMock {
        private TwitterIntegrationController.TweetResponse response;
        private Boolean throwError;

        TwitterIntegrationMock(TwitterIntegrationController.TweetResponse response, Boolean throwError) {
            this.response = response;
            this.throwError = throwError;
        }

        TwitterIntegrationMock(TwitterIntegrationController.TweetResponse response) {
            this(response, false);
        }

        public HTTPResponse respond(HTTPRequest req) {
            String json_str = '{"data":{"edit_history_tweet_ids":["12345"],"id":"12345","text":"test"}}';
            if (throwError) {
                throw new CalloutException('Callout failed.');
            }

            HttpResponse res = new HttpResponse();
            res.setStatusCode(201);
            res.setHeader('Content-Type', 'application/json');
            res.setBody(json_str);
            return res;
        }
    }
}