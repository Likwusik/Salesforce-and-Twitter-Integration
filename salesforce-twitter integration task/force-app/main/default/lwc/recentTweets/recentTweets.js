import { LightningElement, wire } from 'lwc';
import getRecentTweets from '@salesforce/apex/TweetController.getRecentTweets';
import deleteTweet from '@salesforce/apex/TwitterIntegrationController.deleteTweet';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import getTweetToDelete from '@salesforce/apex/TweetController.getTweetToDelete';


export default class RecentTweets extends LightningElement {
    
// Wire the Apex method to fetch recent tweets
    @wire(getRecentTweets) tweets;

// Format tweet data for display
    get formattedTweets() {
        if (this.tweets.data) {
            console.log('Raw Tweet Data:', this.tweets.data); // Debugging line
            return this.tweets.data.map(tweet => ({
                // Map and format each tweet object
                Id: tweet.Id,                // Salesforce record ID
                Tweet_Title__c: tweet.Tweet_Title__c,
                Tweet_ID__c: tweet.Tweet_ID__c, // Custom field from Twitter API
                createdByName: tweet.CreatedBy ? tweet.CreatedBy.Name : 'Unknown',
                formattedDate: this.formatDate(tweet.Tweet_Date__c)
            }));
        } else {
            return [];
        }
    }

    // Convert date string to a readable format
    formatDate(dateString) {
        if (!dateString) return 'Unknown Date';
        
        const date = new Date(dateString);
        const options = {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit'
        };
        // Format date according to options
        return new Intl.DateTimeFormat('en-GB', options).format(date);
    }

    handleTweetClick(event) {
        const recordID = event.target.dataset.id;
        window.open(`/lightning/r/Tweet__c/${recordID}/view`, "_blank");
    }

    handleDeleteTweet(event) {
        const tweetId = event.target.dataset.id;

        deleteTweet({ tweetId })

            .then(() => {
                getTweetToDelete({ tweetId })
                    this.dispatchEvent(new ShowToastEvent({
                        title: 'Success',
                        message: 'Tweet deleted successfully',
                        variant: 'success',
                    }));
            
                    return  refreshApex(this.tweets);
                   
               
            })
            .catch(error => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error',
                }));
            }).finally(() => {
                this.refreshView();
            });

    }  refreshView() {
        console.log('Refreshing view...');
        window.location.reload();
    }

}