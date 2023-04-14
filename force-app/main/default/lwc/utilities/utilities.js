import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export const showToast = (title, message, variant, mode) => {
  // TODO: Update message to be able to handle error objects as well
  dispatchEvent(new ShowToastEvent({
    'title': title,
    'message': message,
    'variant': variant || 'error',
    'mode': mode || 'dismissable'
  }));
}
