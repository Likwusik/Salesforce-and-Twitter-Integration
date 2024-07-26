import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createTweet from '@salesforce/apex/CreateTweetController.createTweet';

export default class CreateTweetComponent extends LightningElement {
    // Stores the title and text of the tweet
    @track tweetTitle = ''; 
    @track tweetText = '';

    // Handles changes to the tweet title input field
    handleTweetTitleChange(event) {
        this.tweetTitle = event.target.value; // Update tweetTitle with the input value
    }

    // Handles changes to the tweet text input field
    handleTweetTextChange(event) {
        this.tweetText = event.target.value;
    }

    // Posts a new tweet by calling the Apex method
    async postTweet() {
        try {
            // Call the Apex method to create a tweet
            await createTweet({ tweetTitle: this.tweetTitle, tweetText: this.tweetText });
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: 'Tweet posted successfully',
                variant: 'success'
            }));
            this.clearForm();
            this.refreshView();
        } catch (error) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error posting tweet',
                message: error.body.message,
                variant: 'error'
            }));
        }
    }

    cancel() {
        this.clearForm();
    }

    clearForm() {
        this.tweetTitle = '';
        this.tweetText = '';
    }

    refreshView() {
        window.location.reload();
    }
}