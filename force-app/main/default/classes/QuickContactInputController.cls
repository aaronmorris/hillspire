public with sharing class QuickContactInputController {
  @AuraEnabled
  public static Contact createContact(Contact contact, Id grantId){
    // TODO: Create a generic permission check utility
    if (Schema.sObjectType.Contact.isCreateable() == false
      || Schema.sObjectType.Contact.fields.FirstName.isCreateable() == false
      || Schema.sObjectType.Contact.fields.LastName.isCreateable() == false
      || Schema.sObjectType.Contact.fields.Email.isCreateable() == false
      || Schema.sObjectType.Grant_Contact__c.isCreateable() == false
      || Schema.sObjectType.Grant_Contact__c.fields.Grant__c.isCreateable() == false
      || Schema.sObjectType.Grant_Contact__c.fields.Grantee__c.isCreateable() == false) {
      throw new AuraHandledException('The current user does not have the correct permission to create a Grant Contact');
    }

    try {
      // Should the contact be created if the Grant_Contact__c fails, or should there be a Savepoint/Rollback
      insert contact;
      insert new Grant_Contact__c (Grant__c = grantId, Grantee__c = contact.Id);
    }
    catch (Exception ex) {
      throw new AuraHandledException(ex.getMessage());
    }

    return contact;
  }
}