public with sharing class LogService {

    public static void logError(LogDetails logDetails) {
        if (Schema.sObjectType.Log__c.isCreateable()) {
            Log__c log = new Log__c(
                Class_Name__c = logDetails.className,
                User_Friendly_Message__c = logDetails.userFriendlyMessage,
                Message__c = logDetails.message,
                StackTrace__c = logDetails.stackTrace
            );
            try {
                insert log;
            } catch (Exception e) {
                System.debug('Error inserting log record: ' + e.getMessage());
            }
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