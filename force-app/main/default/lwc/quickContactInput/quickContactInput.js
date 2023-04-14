import { LightningElement, api } from 'lwc';

import { showToast } from 'c/utilities';

import createContact from '@salesforce/apex/QuickContactInputController.createContact';

export default class QuickContactInput extends LightningElement {
  @api grantId;

  saveButtonDisabled = true;
  saving = false;

  firstName;
  lastName;
  email;

  handleFirstNameChange(event) {
    this.firstName = event.target.value;
    this.saveButtonDisabled = !this.isFormValid();
  }

  handleLastNameChange(event) {
    this.lastName = event.target.value;
    this.saveButtonDisabled = !this.isFormValid();
  }

  handleEmailChange(event) {
    this.email = event.target.value;
    this.saveButtonDisabled = !this.isFormValid();
  }

  async handleSave() {
    this.saving = true;

    const contact = {
      sObjectType: "Contact",
      FirstName: this.firstName,
      LastName: this.lastName,
      Email: this.email
    };

    try {
      await createContact({contact: contact, grantId: this.grantId});
      this.dispatchEvent(new CustomEvent('contactcreated'));
      this.clearForm();
      this.saveButtonDisabled = true;
      showToast('Success', 'Contact Created Successfully', 'success', 'dismissable');
    }
    catch (error) {
      console.error(error);
      let errorMessage = error.body.message;
      if (!errorMessage) {
        errorMessage = 'There was an error creating the contact';
      }

      showToast('Error', errorMessage, 'error', 'dismissable');
    }

    this.saving = false;
  }

  clearForm() {
    const inputs = this.template.querySelectorAll('lightning-input');

    for (const input of inputs) {
      input.value = '';
    }
  }

  isFormValid() {
    const inputs = this.template.querySelectorAll('lightning-input');

    for (const input of inputs) {
      if (input.checkValidity() === false) {
        return false;
      }
    }

    return true;
  }
}