import { LightningElement, track, wire } from 'lwc';
import getAllTweets from '@salesforce/apex/TweetController.getAllTweets';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class AllTweets extends LightningElement {
    @track tweets;
    @track pageSize = 10;
    @track pageNumber = 1;
    @track totalTweets = 0;
    @track disablePrevious = true;
    @track disableNext = true;

    @wire(getAllTweets)
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
                createdByName: tweet.CreatedBy ? tweet.CreatedBy.Name : 'Unknown',
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

    handleTweetClick(event) {
        const recordID = event.target.dataset.id;
        window.open(`/lightning/r/Tweet__c/${recordID}/view`, "_blank");
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
