@isTest
public with sharing class QuickContactListControllerTest {
  @isTest
  private static void getGrantContacts() { // NOPMD - ApexUnitTestClassShouldHaveAsserts - Using new Assert class
    Grant__c testGrant = new Grant__c(Name = 'Test Grant');
    insert testGrant;

    Contact contact = new Contact(FirstName = 'First', LastName = 'Last', Email = 'first.last@example.com');
    insert contact;

    Grant_Contact__c grantContact = new Grant_Contact__c(Grantee__c = contact.Id, Grant__c = testGrant.Id);
    insert grantContact;

    Test.startTest();
    List<QuickContactListController.GrantContact> grantContacts = QuickContactListController.getGrantContacts(testGrant.Id);
    Test.stopTest();

    Assert.areEqual(1, grantContacts.size(), 'should be one GrantContact');
    Assert.areEqual(contact.FirstName, grantContacts[0].firstName, 'first names should match');
    Assert.areEqual(contact.LastName, grantContacts[0].lastName, 'last names should match');
    Assert.areEqual(contact.Email, grantContacts[0].email, 'emails should match');
    Assert.areEqual(contact.Id, grantContacts[0].contactId, 'contact ids should match');
    Assert.areEqual('/' + contact.Id, grantContacts[0].contactLink, 'contact link should match the id as link');
  }

  @isTest
  private static void getGrantContacts_nullGrantId() { // NOPMD - ApexUnitTestClassShouldHaveAsserts - Using new Assert class
    Grant__c testGrant = new Grant__c(Name = 'Test Grant');
    insert testGrant;

    Contact contact = new Contact(FirstName = 'First', LastName = 'Last', Email = 'first.last@example.com');
    insert contact;

    Grant_Contact__c grantContact = new Grant_Contact__c(Grantee__c = contact.Id, Grant__c = testGrant.Id);
    insert grantContact;

    Test.startTest();
    List<QuickContactListController.GrantContact> grantContacts = QuickContactListController.getGrantContacts(null);
    Test.stopTest();

    Assert.areEqual(0, grantContacts.size(), 'no GrantContacts should be returned');
  }

  @isTest
  private static void getGrantContacts_noAccess() { // NOPMD - ApexUnitTestClassShouldHaveAsserts - Using new Assert class
    Grant__c testGrant = new Grant__c(Name = 'Test Grant');
    insert testGrant;

    Contact newContact = new Contact(FirstName = 'First', LastName = 'Last', Email = 'first.last@example.com');
    insert newContact;

    Grant_Contact__c grantContact = new Grant_Contact__c(Grantee__c = newContact.Id, Grant__c = testGrant.Id);
    insert grantContact;

    List<QuickContactListController.GrantContact> grantContacts;
    Boolean exceptionCaught = false;
    System.runAs(TestUtilities.fabricateUser('Chatter Free User')) {
      Test.startTest();
      try {
        grantContacts = QuickContactListController.getGrantContacts(testGrant.Id);
      }
      catch (AuraHandledException aex) {
        exceptionCaught = true;
      }
      Test.stopTest();
    }

    Assert.isTrue(exceptionCaught, 'exception should have been thrown');
    Assert.areEqual(null, grantContacts, 'no GrantContacts should have been');
  }
}