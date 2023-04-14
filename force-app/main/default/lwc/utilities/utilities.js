import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export const showToast = (title, message, variant, mode) => {
  dispatchEvent(new ShowToastEvent({
    'title': title,
    'message': message,
    'variant': variant || 'error',
    'mode': mode || 'dismissable'
  }));
}
