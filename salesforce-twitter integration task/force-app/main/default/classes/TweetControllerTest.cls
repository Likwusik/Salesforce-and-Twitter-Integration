@isTest
public class TweetControllerTest {
    
    @isTest
    static void testGetRecentTweets() {
        // Arrange: Create some test tweet records with valid lengths for fields
        List<Tweet__c> tweets = new List<Tweet__c>{
            new Tweet__c(Tweet_Title__c='Tweet 1', Tweet_Text__c='Text 1', Tweet_Date__c=System.now().addDays(-1)),
            new Tweet__c(Tweet_Title__c='Tweet 2', Tweet_Text__c='Text 2', Tweet_Date__c=System.now().addDays(-2)),
            new Tweet__c(Tweet_Title__c='Tweet 3', Tweet_Text__c='Text 3', Tweet_Date__c=System.now().addDays(-3))
        };
        insert tweets;
        
        // Act: Call the method
        Test.startTest();
        List<Tweet__c> recentTweets = TweetController.getRecentTweets();
        Test.stopTest();
        
        // Assert: Verify the results
        System.assertEquals(3, recentTweets.size(), 'The number of tweets should be 3.');
        System.assertEquals('Tweet 1', recentTweets[0].Tweet_Title__c, 'The most recent tweet title should be "Tweet 1".');
    }
    
    @isTest
    static void testGetTweetsCreatedByMe() {
        // Arrange: Create some tweets with the current user as the creator
        User currentUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        Tweet__c tweet1 = new Tweet__c(Tweet_Title__c='User Tweet 1', Tweet_Text__c='Text 1', Tweet_Date__c=System.now().addDays(-1));
        Tweet__c tweet2 = new Tweet__c(Tweet_Title__c='User Tweet 2', Tweet_Text__c='Text 2', Tweet_Date__c=System.now().addDays(-2));
        insert new List<Tweet__c>{tweet1, tweet2};
        
        // Act: Call the method
        Test.startTest();
        List<Tweet__c> userTweets = TweetController.getTweetsCreatedByMe();
        Test.stopTest();
        
        // Assert: Verify the results
        System.assertEquals(2, userTweets.size(), 'The number of tweets created by me should be 2.');
        System.assertEquals('User Tweet 1', userTweets[0].Tweet_Title__c, 'The most recent tweet title should be "User Tweet 1".');
    }
    
    @isTest
    static void testGetAllTweets() {
        // Arrange: Create some test tweet records with valid lengths for fields
        List<Tweet__c> tweets = new List<Tweet__c>{
            new Tweet__c(Tweet_Title__c='Tweet A', Tweet_Text__c='Text A', Tweet_Date__c=System.now().addDays(-1)),
            new Tweet__c(Tweet_Title__c='Tweet B', Tweet_Text__c='Text B', Tweet_Date__c=System.now().addDays(-2))
        };
        insert tweets;
        
        // Act: Call the method
        Test.startTest();
        List<Tweet__c> allTweets = TweetController.getAllTweets();
        Test.stopTest();
        
        // Assert: Verify the results
        System.assertEquals(2, allTweets.size(), 'The number of tweets should be 2.');
        System.assertEquals('Tweet A', allTweets[0].Tweet_Title__c, 'The most recent tweet title should be "Tweet A".');
    }
    
    @isTest
    static void testGetTweetToDelete() {
        // Arrange: Create a tweet record to delete with valid length for fields
        Tweet__c tweetToDelete = new Tweet__c(Tweet_Title__c='Tweet to Delete', Tweet_Text__c='Text to Delete', Tweet_Date__c=System.now());
        insert tweetToDelete;
        
        // Act: Call the method to delete the tweet
        Test.startTest();
        TweetController.getTweetToDelete(tweetToDelete.Tweet_ID__c);
        Test.stopTest();
        
        // Assert: Verify the record has been deleted
        List<Tweet__c> deletedTweets = [SELECT Id FROM Tweet__c WHERE Tweet_ID__c = :tweetToDelete.Tweet_ID__c LIMIT 1];
        System.assertEquals(0, deletedTweets.size(), 'The tweet should be deleted.');
    }
    
    @isTest
    static void testGetTweetToDelete_Exception() {
        // Arrange: Create a tweet record but simulate an error during deletion
        Tweet__c tweet = new Tweet__c(Tweet_Title__c='Error Tweet', Tweet_Text__c='Text to Simulate Error', Tweet_Date__c=System.now());
        insert tweet;
        
        // Simulate a scenario where tweet ID does not exist (invalid ID)
        String invalidTweetId = 'non-existent-id';
        
        // Act and Assert: Verify exception handling
        Test.startTest();
        try {
            TweetController.getTweetToDelete(invalidTweetId);
            System.assert(false, 'An exception should have been thrown for invalid Tweet ID.');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('Error in deleting tweet:'), 'The exception message should indicate an error in deleting the tweet.');
        }
        Test.stopTest();
    }
}