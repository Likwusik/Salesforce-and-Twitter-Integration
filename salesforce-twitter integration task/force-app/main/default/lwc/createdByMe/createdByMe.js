import { LightningElement, track, wire } from 'lwc';
import getTweetsCreatedByMe from '@salesforce/apex/TweetController.getTweetsCreatedByMe';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class CreatedByMe extends LightningElement {
    @track tweets;
    @track pageSize = 5;
    @track pageNumber = 1;
    @track totalTweets = 0;
    @track disablePrevious = true;
    @track disableNext = true;

    @wire(getTweetsCreatedByMe)
    wiredTweets(result) {
        this.tweets = result;
        if (result.data) {
            this.totalTweets = result.data.length;
            this.updatePaginationButtons();
        }
    }

    get paginatedTweets() {
        if (this.tweets.data) {
            const start = (this.pageNumber - 1) * this.pageSize;
            const end = start + this.pageSize;
            return this.tweets.data.slice(start, end).map(tweet => ({
                Id: tweet.Id,
                Tweet_Title__c: tweet.Tweet_Title__c,
                Tweet_ID__c: tweet.Tweet_ID__c,
                Tweet_Text__c: tweet.Tweet_Text__c,
                formattedDate: this.formatDate(tweet.Tweet_Date__c)
            }));
        }
        return [];
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
        return new Intl.DateTimeFormat('en-GB', options).format(date);
    }

    handlePrevious() {
        if (this.pageNumber > 1) {
            this.pageNumber -= 1;
            this.updatePaginationButtons();
        }
    }

    handleNext() {
        if ((this.pageNumber * this.pageSize) < this.totalTweets) {
            this.pageNumber += 1;
            this.updatePaginationButtons();
        }
    }

    updatePaginationButtons() {
        this.disablePrevious = this.pageNumber === 1;
        this.disableNext = (this.pageNumber * this.pageSize) >= this.totalTweets;
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}
