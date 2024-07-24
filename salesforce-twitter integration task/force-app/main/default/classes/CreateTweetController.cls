public with sharing class CreateTweetController {
    @AuraEnabled
    public static void createTweet(Id contactId, String tweetText) {
        Contact contact = [SELECT Id, Twitter_Handle__c FROM Contact WHERE Id = :contactId WITH SECURITY_ENFORCED LIMIT 1];
        
        if (contact.Twitter_Handle__c == null) {
            throw new AuraHandledException('The contact does not have a Twitter handle.');
        }
        
        if (tweetText == null || tweetText.length() > 280) {
            throw new AuraHandledException('Tweet text must be between 1 and 280 characters.');
        }
        
        try {
            TwitterIntegrationController.TweetResponse tweetResponse = TwitterIntegrationController.postTweet(contact.Twitter_Handle__c, tweetText);

            Tweet__c tweet = new Tweet__c(
                Contact__c = contact.Id,
                Tweet_Text__c = tweetText,
                Tweet_Date__c = System.now(),
                Tweet_ID__c = tweetResponse.id
            );
            insert tweet;
            
            contact.Last_Tweet_Post_Date__c = System.now();
            update contact;
        } catch (Exception e) {
            LogService.logError(new LogService.LogDetails(
                'CreateTweetController',
                'Failed to post tweet',
                e.getMessage(),
                e.getStackTraceString()
            ));
            throw new AuraHandledException('Failed to post tweet: ' + e.getMessage());
        }
    }
}