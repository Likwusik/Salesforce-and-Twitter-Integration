import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createTweet from '@salesforce/apex/CreateTweetController.createTweet';

export default class CreateTweetComponent extends LightningElement {
    @api recordId;
    @track tweetText = '';

    handleTweetTextChange(event) {
        this.tweetText = event.target.value;
    }

    async postTweet() {
        try {
            await createTweet({ contactId: this.recordId, tweetText: this.tweetText });
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: 'Tweet posted successfully',
                variant: 'success'
            }));
            this.closeQuickAction();
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
        this.closeQuickAction();
    }

    closeQuickAction() {
        const closeQA = new CustomEvent('closequickaction', {
            bubbles: true,
            composed: true
        });
        this.dispatchEvent(closeQA);
    }

    refreshView() {
        const refreshEvent = new CustomEvent('force:refreshView');
        this.dispatchEvent(refreshEvent);
    }
}