public with sharing class CreateTweetController {
    @AuraEnabled
    public static void createTweet(String tweetTitle, String tweetText) {
        if (tweetText == null || tweetText.length() > 280) {
            throw new AuraHandledException('Tweet text must be between 1 and 280 characters.');
        }
        
        if (tweetTitle == null || tweetTitle.length() == 0) {
            throw new AuraHandledException('Tweet title is required.');
        }

        System.debug('test');
        
        try {
            TwitterIntegrationController.TweetResponse tweetResponse = TwitterIntegrationController.postTweet(tweetText);

            Tweet__c tweet = new Tweet__c(
                Tweet_Title__c = tweetTitle,
                Tweet_Text__c = tweetText,
                Tweet_Date__c = System.now(),
                Tweet_ID__c = tweetResponse.id
            );

            insert tweet;

            System.debug('id:' + tweetResponse.id);
            
        } catch (Exception e) {
            LogService.logError(new LogService.LogDetails(
                'CreateTweetController',
                'Failed to post tweet',
                e.getMessage(),
                e.getStackTraceString()
            ));

            System.debug(e.getMessage());
            // throw new AuraHandledException('Failed to post tweet: ' + e.getMessage());

        }
    }
}
