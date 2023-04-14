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
    console.log(event.target);
    this.email = event.target.value;
    this.saveButtonDisabled = !this.isFormValid();
  }

  async handleSave() {
    this.saving = true;

    const contact = {
      sobjectType: "Contact",
      FirstName: this.firstName,
      LastName: this.lastName,
      Email: this.email
    };

    // TODO: Add try/catch
    // TODO: Add success message
    // TODO: disable/enable save button
    try {
      await createContact({contact: contact, grantId: this.grantId});
      this.dispatchEvent(new CustomEvent('contactcreated'));
      this.clearForm();
      showToast('Contact Created Successfully', '', 'success', 'dismissable');
    }
    catch (error) {

    }
    this.saving = false;
  }

  clearForm() {
    const inputs = this.template.querySelectorAll('lightning-input');
    console.log(inputs.length);

    for (const input of inputs) {
      input.value = '';
    }
  }

  isFormValid() {
    const inputs = this.template.querySelectorAll('lightning-input');
    console.log(inputs.length);

    for (const input of inputs) {
      if (input.checkValidity() === false) {
        return false;
      }
    }

    return true;
  }
}