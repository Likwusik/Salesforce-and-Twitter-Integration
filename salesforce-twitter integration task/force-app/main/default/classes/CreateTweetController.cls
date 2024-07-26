public with sharing class CreateTweetController {
    @AuraEnabled

    // Creates a tweet and saves it to Salesforce
    public static void createTweet(String tweetTitle, String tweetText) {
        // Validate tweet text length
        if (tweetText == null || tweetText.length() > 280) {
            throw new AuraHandledException('Tweet text must be between 1 and 280 characters.');
        }
        
         // Validate tweet title
        if (tweetTitle == null || tweetTitle.length() == 0) {
            throw new AuraHandledException('Tweet title is required.');
        }
        
        try {
            // Post the tweet to Twitter and get the response
            TwitterIntegrationController.TweetResponse tweetResponse = TwitterIntegrationController.postTweet(tweetText);

            // Correct instantiation of the Tweet__c object
            Tweet__c tweet = new Tweet__c(
                Tweet_Title__c = tweetTitle,
                Tweet_Text__c = tweetText,
                Tweet_Date__c = System.now(),
                Tweet_ID__c = tweetResponse.id
            );

            try {
                // Insert the new Tweet__c record into Salesforce
                insert tweet;
            } catch (DmlException e) {
                // Handle and log any errors that occur during DML operations
                System.debug('DML Exception Message: ' + e.getMessage());
                System.debug('DML Exception Stack Trace: ' + e.getStackTraceString());
                LogService.logError(new LogService.LogDetails(
                    'CreateTweetController',
                    'Failed to insert Tweet__c record',
                    e.getMessage(),
                    e.getStackTraceString()
                ));
                throw new AuraHandledException('Failed to save tweet to Salesforce.');
            }
        } catch (CalloutException e) {
            // Handle and log any errors that occur during the callout to Twitter
            LogService.logError(new LogService.LogDetails(
                'CreateTweetController',
                'Failed to post tweet',
                e.getMessage(),
                e.getStackTraceString()
            ));
            throw new AuraHandledException('Failed to post tweet to external service.');
        }
    }
}