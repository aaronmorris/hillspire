import { LightningElement, api, wire, track } from 'lwc';

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
  @api grantId = '';

  columns = columns;
  grantContacts = [];
  wiredGrantContactsResult;

  @wire(getGrantContacts, {grantId: '$grantId'})
  wireGetGrantContacts(result) {
    this.wiredGrantContactsResult = result;
    if (result.data) {
      console.log('data:', result.data);
      this.grantContacts = result.data;
    }
    else if (result.error) {
      console.error(result.error);
      // TODO: do something with the error
    }
  }

  @api refresh() {
    console.log('refresh');
    return refreshApex(this.wiredGrantContactsResult);
    console.log('after refresh');
    console.log(this.grantContacts);
  }
}