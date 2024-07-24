import { LightningElement, wire, track } from 'lwc';
import getAllTweets from '@salesforce/apex/TweetController.getAllTweets';

export default class AllTweets extends LightningElement {
    @track tweets = [];
    @track pageSize = 10;
    @track currentPage = 1;
    @track totalTweets = 0;

    @wire(getAllTweets, { pageSize: '$pageSize', pageNumber: '$currentPage' })
    wiredTweets(result) {
        if (result.data) {
            this.tweets = result.data.tweets;
            this.totalTweets = result.data.totalTweets;
        } else if (result.error) {
            console.error(result.error);
        }
    }

    get hasMoreTweets() {
        return this.tweets.length < this.totalTweets;
    }

    loadMore() {
        if (this.hasMoreTweets) {
            this.currentPage += 1;
        }
    }
}