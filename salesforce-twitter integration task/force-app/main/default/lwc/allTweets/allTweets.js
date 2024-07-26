import { LightningElement, track, wire } from 'lwc';
import getAllTweets from '@salesforce/apex/TweetController.getAllTweets';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AllTweets extends LightningElement {
    @track tweets; // Array to hold the list of tweets fetched from the server
    @track pageSize = 10;
    @track pageNumber = 1;
    @track totalTweets = 0;
    @track disablePrevious = true;
    @track disableNext = true;

    // Wire adapter to fetch tweets from the server using the Apex method
    @wire(getAllTweets)
    wiredTweets(result) {
        this.tweets = result; // Store the result of the wired method
        if (result.data) {
            this.totalTweets = result.data.length; // Update the total number of tweets
            this.updatePaginationButtons(); // Update the state of pagination buttons based on the data
        }
    }

    // Getter to return the subset of tweets to display based on the current page and page size
    get paginatedTweets() {
        
        if (this.tweets.data) {
            // Calculate the start and end index for slicing the tweets array
            const start = (this.pageNumber - 1) * this.pageSize;
            const end = start + this.pageSize;
            // Slice the tweets array and format each tweet for display
            return this.tweets.data.slice(start, end).map(tweet => ({
                Id: tweet.Id,
                Tweet_Title__c: tweet.Tweet_Title__c,
                Tweet_ID__c: tweet.Tweet_ID__c,
                createdByName: tweet.CreatedBy ? tweet.CreatedBy.Name : 'Unknown',
                formattedDate: this.formatDate(tweet.Tweet_Date__c)
            }));
        } else {
        return []; // Return an empty array if no data is available
        }
    }

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
        // Format the date according to the specified options and return the formatted string
        return new Intl.DateTimeFormat('en-GB', options).format(date);
    }

    // Event handler for clicking a tweet to open its detail view in a new tab
    handleTweetClick(event) {
        const recordID = event.target.dataset.id; // Retrieve the tweet ID from the clicked element's dataset
        window.open(`/lightning/r/Tweet__c/${recordID}/view`, "_blank"); // Open the tweet detail page in a new tab
    }

// Event handler for navigating to the previous page of tweets
    handlePrevious() {
        if (this.pageNumber > 1) {
            this.pageNumber -= 1;
            this.updatePaginationButtons();
        }
    }

    // Event handler for navigating to the next page of tweets
    handleNext() {
        if ((this.pageNumber * this.pageSize) < this.totalTweets) {
            this.pageNumber += 1;
            this.updatePaginationButtons();
        }
    }

    // Method to update the state of pagination buttons (enabled/disabled)
    updatePaginationButtons() {
        this.disablePrevious = this.pageNumber === 1;
        this.disableNext = (this.pageNumber * this.pageSize) >= this.totalTweets;
    }

    // Method to show toast messages for user feedback
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}