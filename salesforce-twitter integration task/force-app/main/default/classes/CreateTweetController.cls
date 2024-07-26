public with sharing class CreateTweetController {
    @AuraEnabled
    public static void createTweet(String tweetTitle, String tweetText) {
        if (tweetText == null || tweetText.length() > 280) {
            throw new AuraHandledException('Tweet text must be between 1 and 280 characters.');
        }
        
        if (tweetTitle == null || tweetTitle.length() == 0) {
            throw new AuraHandledException('Tweet title is required.');
        }
        
        try {
            TwitterIntegrationController.TweetResponse tweetResponse = TwitterIntegrationController.postTweet(tweetText);

            // Correct instantiation of the Tweet__c object
            Tweet__c tweet = new Tweet__c(
                Tweet_Title__c = tweetTitle,
                Tweet_Text__c = tweetText,
                Tweet_Date__c = System.now(),
                Tweet_ID__c = tweetResponse.id
            );

            try {
                insert tweet;
            } catch (DmlException e) {
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