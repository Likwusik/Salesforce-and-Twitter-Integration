import { LightningElement, wire } from 'lwc';
import getTweetsCreatedByMe from '@salesforce/apex/TweetController.getTweetsCreatedByMe';

export default class CreatedByMe extends LightningElement {
    @wire(getTweetsCreatedByMe) tweets;
}
