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
    - _CreatedByMe_ to show Tweets that were created by current user with two buttons (previous, next) which allows us to see 5 tweets on one page
    - _AllTweets_ to show data table of all Tweets that were created with two buttons (previous, next) which allows us to see 10 tweets on one page
 - [x] Create TweetController (test coverage: 100%) for LWC Components that get required Tweets
 - [X] All records are made be clickable in every LWC

# Result Visualisation:

**1)** The first look of created Visualforce Page with the _CreateTweetComponent_ component.
 <img src="salesforce-twitter integration task/images\page.jpg"/> 

**2)** Creating the Tweet and posting it
 <img src="salesforce-twitter integration task/images\create.jpg"/>
 <img src="salesforce-twitter integration task/images\result.jpg"/>

**3)** Showing _RecentTweet_ component with just created Tweet and _delete_ button 
<img src="salesforce-twitter integration task/images\recent.jpg"/>

**4)** Showing _CreatedByMe_ component with just created Tweet. We can see, that we can press _next_ to view the next page (5 tweets per page)
<img src="salesforce-twitter integration task/images\me.jpg"/>
<img src="salesforce-twitter integration task/images\me2.jpg"/>

**3)** Showing _AllTweets_ component with just created Tweet. We can see, that we can press _next_ to view the next page. All Tweets are displayed in data table (10 tweets per page)
<img src="salesforce-twitter integration task/images\all.jpg"/>
<img src="salesforce-twitter integration task/images\all2.jpg"/>

**4)** Representation of the _delete_ button. We can see, that the Tweet is deleted from all components, from Twiter and from Salesforce in general (checked by inspector) 

<img src="salesforce-twitter integration task/images\tweets.jpg"/>
<img src="salesforce-twitter integration task/images\happy.jpg"/>
<img src="salesforce-twitter integration task/images\nothappy.jpg"/>
<img src="salesforce-twitter integration task/images\nothappy1.jpg"/>
<img src="salesforce-twitter integration task/images\nothappy2.jpg"/>
<img src="salesforce-twitter integration task/images\nothappy3.jpg"/>

**5)** Representation that records of the Order object displayed by the component are clickable. 
<img src="salesforce-twitter integration task/images\show.jpg"/>
<img src="salesforce-twitter integration task/images\show2.jpg"/>




