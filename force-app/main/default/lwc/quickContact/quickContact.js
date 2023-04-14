import { LightningElement, api } from 'lwc';

export default class QuickContact extends LightningElement {
  @api recordId;

  handleContactCreated() {
    console.log('handleContactCreated');
    this.template.querySelector('c-quick-contact-list').refresh();
  }
}