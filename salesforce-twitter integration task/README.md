# Salesforce-and-Twitter-Integration

# Task description
I need to create an application that allows me to create and post tweets through Salesforce on my Twitter Page. In addition to that this system should store posted tweets and display the most recent tweets with the ability to delete them from Twitter using _delete_ button. Also I decided to add two different tables that contain all tweets and tweets that were created by the current user.  

> [!NOTE]
> The original task was changed by me because of my desire to try different solutions. That is why some requirements are different than expected in the original task. 
> Original task: Create an integration between Salesforce and an external Social Media Platform (e.g., Twitter) to create and post tweets from a Contact on their Twitter page. This system should store posted tweets and display them on the Contact record page.

# Steps to complete the task

**Step 1. - _Data model:_**

- [x] Create Custom object: "Tweet" with fields: "Tweet Text" (long text area), "Tweet Date" (date/time), and "Tweet ID" (text).

**Step 2. - _Integration Setup:_**
- [x] Create test personal Twitter account and twitter developer lab.
- [x] Storage of auth data (Custom Metadata Type) for OAuth1.0 (got to know Named Credentials/Auth providers as well)
- [x] Configure Remote Site Settings to allow Salesforce to communicate with the Twitter API.
- [x] Create an Apex class to call the Twitter API, send request/handle response and generate needed Authorization Header:
   - _TwitterIntegrationController_ (test coverage: 100%)
   - _Twitter0Auth1_ (test coverage: 100%)
      
**Step 3. - _Application:_**
- [x] Create Visualforce Page: _Twitter Page_
- [x] Create 5 LWC Components:
    - _CreateTweetComponent_ with CreateTweetComponentController (test coverage: 75%) to create Tweet with two buttons (post, delete)
    - _RecentTweets_ to show 5 tecent Tweets with _delete_ button
    - _TwitterNavigation_ to create navigation bar that allows us to swith between components
    - _CreatedByMe_ to show Tweets that were created by current user with two buttons (previous,     next) which allows us to see 5 tweets on one page
    - _AllTweets_ to show data table of all Tweets that were created with two buttons (previous,     next) which allows us to see 10 tweets on one page
 - [x] Create TweetController (test coverage: 100%) for LWC Components that get required Tweets

# Result Visualisation:

 **1)** First picklist that contains the names of all records from the Account object that have one or more related Orders.
 <img src="jetbitask\images\first_picklist.jpg"/>
 <img src="jetbitask\images\first_picklist1.jpg"/>

**2)** Second picklist that contains names of all months of Payment Due Date records filtered by the first one.
<img src="jetbitask\images\second_picklist.jpg"/>
<img src="jetbitask\images\seond_picklist1.jpg"/>

**3)** Order list with the chosen details. The records of the Order object displayed by the component is clickable
<img src="jetbitask\images\order_list.jpg"/>
<img src="jetbitask\images\order_details.jpg"/>

**4)** Button “Send Order” on the Order object that sends an email to current User with Order details after confirmation
<img src="jetbitask\images\button.jpg"/>
<img src="jetbitask\images\confirmation.jpg"/>

**5)** The email that contains information about payment due date, total sum, customer name and JetBI logo
<img src="jetbitask\images\email.jpg"/>




