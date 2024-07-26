public with sharing class Twitter0Auth1 {

    // Retrieve Twitter API settings from custom metadata
    private static Twitter_API_Setting__mdt twitterSettings = Twitter_API_Setting__mdt.getInstance('Default_Configuration');

    // OAuth credentials from Twitter API settings
    private static final String CONSUMER_KEY = twitterSettings.API_Key__c;
    private static final String CONSUMER_SECRET = twitterSettings.API_Key_Secret__c;
    private static final String ACCESS_TOKEN = twitterSettings.Access_Token__c; 
    private static final String ACCESS_TOKEN_SECRET = twitterSettings.Access_Token_Secret__c;

    // Generates the OAuth 1.0a authorization header
    public static String getAuthorizationHeader(String httpMethod, String endpoint) {
            
        DateTime dateTimeNow = dateTime.now();
        String timestamp = ''+(dateTimeNow.getTime()/1000);
        String nonce = generateNonce();

        // OAuth parameters
        Map<String, String> oauthParams = new Map<String, String>{
            'oauth_consumer_key' => CONSUMER_KEY,
            'oauth_token' => ACCESS_TOKEN,
            'oauth_signature_method' => 'HMAC-SHA1',
            'oauth_timestamp' => timestamp,
            'oauth_nonce' => nonce,
            'oauth_version' => '1.0',
            'oauth_callback'=> 'https%3A%2F%2Flogin.salesforce%2Fcom' 
        }; 
            
        // Generate the OAuth signature
        String authSignature = generateSignature(httpMethod, endpoint, oauthParams);
        oauthParams.put('oauth_signature', authSignature);
		
        // Build the OAuth header
        String oauthHeader = 'OAuth ';
        for (String key : oauthParams.keySet()) {
            String value = oauthParams.get(key);
            oauthHeader += EncodingUtil.urlEncode(key, 'UTF-8') + '="' + EncodingUtil.urlEncode(value, 'UTF-8') + '",';
        }
        oauthHeader = oauthHeader.removeEnd(',');

        return oauthHeader;
    }


    private static String generateNonce() { 
        return generateRandomString(32); 
    }

    public static String generateRandomString(Integer len) { 
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz'; 
        String randStr = ''; 
        while (randStr.length() < len) { 
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length()); 
            randStr += chars.substring(idx, idx+1);
        }
        return EncodingUtil.base64Encode(Blob.valueOf(randStr)).remove('=');
    }
    
    private static String generateSignature(String httpMethod, String baseUrl, Map<String, String> params){
        // Encode parameters
           String encodedString = '';
           Map<String, String> encodeParams = new Map<String, String>();       
           encodeParams.putAll(params);
           
           List<String> keyList = New List<String>();
           keyList.addAll(encodeParams.keySet());
           keyList.sort();
           
           for(String key: keyList){
               encodedString +=  EncodingUtil.urlEncode(key,'UTF-8') + '=' + EncodingUtil.urlEncode(encodeParams.get(key),'UTF-8') + '&';
           }
           encodedString = encodedString.removeEnd('&');
            
            // Create base string for signature
           String baseString = httpMethod.toUpperCase() + '&' + EncodingUtil.urlEncode(baseUrl,'UTF-8') + '&' + EncodingUtil.urlEncode(encodedString,'UTF-8');
           String signingKey = EncodingUtil.urlEncode(CONSUMER_SECRET,'UTF-8') + '&';
           if(params.containsKey('oauth_token') && String.isNotBlank(ACCESS_TOKEN_SECRET)){
               signingKey += EncodingUtil.urlEncode(ACCESS_TOKEN_SECRET,'UTF-8');
           }   
           
           // Generate signature
           Blob data = Crypto.generateMac('hmacSHA1', Blob.valueOf(baseString), Blob.valueOf(signingKey));
           String signature =  EncodingUtil.base64Encode(data);
           return signature;
	}  
}