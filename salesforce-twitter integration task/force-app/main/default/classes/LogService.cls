public with sharing class LogService {

    public static void logError(LogDetails logDetails) {
        if (Schema.sObjectType.Log__c.isCreateable()) {
            Log__c log = new Log__c(
                Class_Name__c = logDetails.className,
                User_Friendly_Message__c = logDetails.userFriendlyMessage,
                Message__c = logDetails.message.length() > 255 ? logDetails.message.substring(0, 255) : logDetails.message,
                StackTrace__c = logDetails.stackTrace
            );
            try {
                insert log;
            } catch (Exception e) {
                // Handle or log the error accordingly
                System.debug('Error inserting log record: ' + e.getMessage());
            }
        } else {
            throw new SecurityException('Insufficient permissions to create Log__c records.');
        }
    }

    public class LogDetails {
        public String className;
        public String userFriendlyMessage;
        public String message;
        public String stackTrace;

        public LogDetails(String className, String userFriendlyMessage, String message, String stackTrace) {
            this.className = className;
            this.userFriendlyMessage = userFriendlyMessage;
            this.message = message;
            this.stackTrace = stackTrace;
        }
    }
}