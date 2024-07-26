import { LightningElement, track } from 'lwc';
import { RefreshEvent } from 'lightning/refresh';

export default class TwitterNavigation extends LightningElement {
    @track selectedItem = 'create';
  
    get isCreate() {
        return this.selectedItem === 'create';
    }

    get isRecent() {
        return this.selectedItem === 'recent';
    }

    get isCreatedByMe() {
        return this.selectedItem === 'created';
    }

    get isAllTweets() {
        return this.selectedItem === 'all';
    }

    handleSelect(event) {
        const selectedName = event.target.name;
        if (selectedName) {
            this.selectedItem = selectedName;
        } else {
            console.error('No selected item found:', event);
        }
    }

    // connectedCallback() {
    //     this.template.addEventListener('tweetposted', this.handleTweetPosted.bind(this));
    // }

    // handleTweetPosted() {
    //     if (this.isRecent) {
    //         const recentTweetsComponent = this.template.querySelector('c-recent-tweets');
    //         if (recentTweetsComponent) {
    //             recentTweetsComponent.refreshTweets();
    //         }
    //     }
    // }
}