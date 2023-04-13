import { LightningElement, api, wire, track } from 'lwc';

import getGrantContacts from '@salesforce/apex/QuickContactListController.getGrantContacts';

const columns = [
  {
    label: 'Id',
    fieldName: 'contactLink',
    type: 'url',
    typeAttributes: { label: { fieldName: 'contactId' }, target: '_blank' }
  },
  // {
  //     label: 'Id',
  //     fieldName: 'id',
  //     type: 'text',
  // },
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

  // async connectedCallback() {
  //   let data = await getGrantContacts({grantId: this.grantId});
  //   data = JSON.parse(JSON.stringify(data));
  //   data.forEach(grantContact => {grantContact.contactLink = '/' + grantContact.Grantee__c});
  //   this.grantContacts = data;
  //   console.log(this.grantContacts);
  // }

  @wire(getGrantContacts, {grantId: '$grantId'})
  wireGetGrantContacts({error, data}) {
    if (data) {
      console.log('data:', data);
      // data = JSON.parse(JSON.stringify(data));
      // data.forEach(grantContact => {grantContact.contactLink = '/' + grantContact.Grantee__c});

      this.grantContacts = data;
    }
    else if (error) {
      console.error(error);
      // TODO: do something with the error
    }
  }
}