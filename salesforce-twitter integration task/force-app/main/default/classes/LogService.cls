public with sharing class LogService {

    public static void logError(LogDetails logDetails) {
        // Check if the Log__c object is creatable
        if (Schema.sObjectType.Log__c.isCreateable()) {
            Log__c log = new Log__c(
                // Create a new instance of Log__c with details from the LogDetails object
                Class_Name__c = logDetails.className,
                User_Friendly_Message__c = logDetails.userFriendlyMessage,
                Message__c = logDetails.message,
                StackTrace__c = logDetails.stackTrace
            );
            try {
                // Attempt to insert the new log record into Salesforce
                insert log;
            } catch (Exception e) {
                // Log error details to the debug log if insertion fails
                System.debug('Error inserting log record: ' + e.getMessage());
            }
        }
    }

    // Encapsulates the details of an error to be logged
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