public with sharing class TweetController {
    @AuraEnabled(cacheable=true)
    public static List<Tweet__c> getRecentTweets() {
        return [SELECT Id, Tweet_Title__c, Tweet_Text__c, Tweet_ID__c, Tweet_Date__c, CreatedBy.Name
                FROM Tweet__c 
                WHERE Tweet_Date__c != null
                AND Tweet_Title__c != null
                AND Tweet_Title__c != ''
                ORDER BY Tweet_Date__c DESC 
                LIMIT 5];
    }

    @AuraEnabled(cacheable=true)
    public static List<Tweet__c> getTweetsCreatedByMe() {
        return [SELECT Id, Tweet_Title__c, Tweet_Text__c, Tweet_Date__c, Tweet_ID__c 
                FROM Tweet__c 
                WHERE CreatedById = :UserInfo.getUserId() 
                AND Tweet_Date__c != null
                AND Tweet_Title__c != null
                AND Tweet_Title__c != ''
                ORDER BY Tweet_Date__c DESC];
    }

    @AuraEnabled(cacheable=true)
    public static List<Tweet__c> getAllTweets() {
        return [SELECT Id, Tweet_Title__c, Tweet_Text__c, Tweet_Date__c, Tweet_ID__c 
                FROM Tweet__c 
                WHERE Tweet_Date__c != null
                AND Tweet_Title__c != null
                AND Tweet_Title__c != ''
                ORDER BY Tweet_Date__c DESC];
    }

    @AuraEnabled(cacheable=false)
    public static void getTweetToDelete(String tweetId) {
       try {
        Tweet__c tweetToDelete = [SELECT Id FROM Tweet__c WHERE Tweet_ID__c = :tweetId LIMIT 1];
       delete tweetToDelete;
       } catch (Exception e) {
        throw new AuraHandledException('Error in deleting tweet: ' + e.getMessage());
       }

    }
}
