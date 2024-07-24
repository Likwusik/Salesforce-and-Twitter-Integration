import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createTweet from '@salesforce/apex/CreateTweetController.createTweet';

export default class CreateTweetComponent extends LightningElement {
    @track tweetTitle = '';
    @track tweetText = '';

    handleTweetTitleChange(event) {
        this.tweetTitle = event.target.value;
    }

    handleTweetTextChange(event) {
        this.tweetText = event.target.value;
    }

    async postTweet() {
        try {
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
        const refreshEvent = new CustomEvent('force:refreshView');
        this.dispatchEvent(refreshEvent);
    }
}
