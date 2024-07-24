public with sharing class TwitterIntegrationController {

    private static Twitter_API_Setting__mdt twitterSettings = Twitter_API_Setting__mdt.getInstance('Default_Configuration');
    private static final String POST_TO_TWITTER_ENDPOINT = twitterSettings.Twitter_Post_URL_Endpoint__c;
    private static final String DELETE_FROM_TWITTER_ENDPOINT = twitterSettings.Twitter_Delete_URL_Endpoint__c;


    public class TweetResponse {
        public String id;
        public String text;
    }

    public static TweetResponse postTweet(String twitterHandle, String tweetText) {
        String url = POST_TO_TWITTER_ENDPOINT;
        System.debug('url' + url);
        String authHeader = Twitter0Auth1.getAuthorizationHeader('POST', url);

        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', authHeader);


        System.debug('generated:' + authHeader);

        Map<String, Object> requestBodyMap = new Map<String,Object>();
        requestBodyMap.put('text', tweetText);
        String requestBody = JSON.serialize(requestBodyMap);
        req.setBody(requestBody);


        //req.setBody('{"status": "' + tweetText + '", "screen_name": "' + twitterHandle + '"}');

        Http http = new Http();
        HttpResponse res = http.send(req);

        // if (res.getStatusCode() != 200) {
        //     throw new CalloutException('Error posting tweet: ' + res.getBody());
        // }

        // Parse response if needed
        System.debug('code ' + res.getStatusCode());
        System.debug('code ' + res.getBody());
        TweetResponse tweetResponse = (TweetResponse) JSON.deserialize(res.getBody(), TweetResponse.class);
        return tweetResponse;
    }

    public static void deleteTweet(String tweetId) {
        String url = DELETE_FROM_TWITTER_ENDPOINT.replace(':id', tweetId);
        String authHeader = Twitter0Auth1.getAuthorizationHeader('DELETE', url);

        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('DELETE');
        req.setHeader('Authorization', authHeader);

        Http http = new Http();
        HttpResponse res = http.send(req);
        
        System.debug('code ' + res.getStatusCode());
        System.debug('code ' + res.getBody());

        if (res.getStatusCode() != 200) {
            throw new CalloutException('Error deleting tweet: ' + res.getBody());
        }
    }
    
}