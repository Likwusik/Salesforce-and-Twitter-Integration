import { LightningElement, track } from 'lwc';

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

    // Handle navigation item selection
    handleSelect(event) {
        const selectedName = event.target.name;
        if (selectedName) {
            this.selectedItem = selectedName;
        } else {
            console.error('No selected item found:', event);
        }
    }
}