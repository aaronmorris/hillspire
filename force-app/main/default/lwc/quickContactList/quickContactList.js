import { LightningElement, api, wire, track } from 'lwc';

import { showToast } from 'c/utilities';

import { refreshApex } from '@salesforce/apex';
import getGrantContacts from '@salesforce/apex/QuickContactListController.getGrantContacts';

const columns = [
  {
    label: 'Id',
    fieldName: 'contactLink',
    type: 'url',
    typeAttributes: { label: { fieldName: 'contactId' }, target: '_blank' }
  },
  {
      label: 'First Name',
      fieldName: 'firstName',
      type: 'text',
  },
  {
    label: 'Last Name',
    fieldName: 'lastName',
    type: 'text',
  },
  {
    label: 'Email',
    fieldName: 'email',
    type: 'text'
  }
];

export default class QuickContactList extends LightningElement {
  @api grantId;

  get hasData() {
    return this.grantContacts.length > 0;
  }

  columns = columns;
  grantContacts = [];
  wiredGrantContactsResult;

  @wire(getGrantContacts, {grantId: '$grantId'})
  wireGetGrantContacts(result) {
    this.wiredGrantContactsResult = result;
    if (result.data) {
      this.grantContacts = result.data;
    }
    else if (result.error) {
      console.error(result.error);
      let errorMessage = result.error.body.message;
      if (!errorMessage) {
        errorMessage = 'There was an error getting the contacts for this Grant';
      }

      showToast('Error', errorMessage, 'error', 'dismissable');
    }
  }

  @api refresh() {
    return refreshApex(this.wiredGrantContactsResult);
  }
}