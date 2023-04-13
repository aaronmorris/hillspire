import { LightningElement, api } from 'lwc';

import createContact from '@salesforce/apex/QuickContactInputController.createContact';

export default class QuickContactInput extends LightningElement {
  @api grantId;

  saveButtonDisabled = true;

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
    const contact = {
      sobjectType: "Contact",
      FirstName: this.firstName,
      LastName: this.lastName,
      Email: this.email
    };

    // TODO: Add try/catch
    // TODO: Add success message
    // TODO: disable/enable save button
    await createContact({contact: contact, grantId: this.grantId});
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