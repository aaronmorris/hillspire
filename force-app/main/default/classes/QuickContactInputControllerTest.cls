@isTest
public with sharing class QuickContactInputControllerTest {
  @isTest
  private static void createContact() { // NOPMD - ApexUnitTestClassShouldHaveAsserts - Using new Assert class
    Grant__c testGrant = new Grant__c(Name = 'Test Grant');
    insert testGrant;

    Contact pendingContact = new Contact(FirstName = 'First', LastName = 'Last', Email = 'first.last@example.com');

    Test.startTest();
    QuickContactInputController.createContact(pendingContact, testGrant.Id);
    Test.stopTest();

    List<Contact> contacts = [SELECT FirstName, LastName, Email FROM Contact];
    List<Grant_Contact__c> grantContacts = [SELECT Grantee__c, Grant__c FROM Grant_Contact__c];

    Assert.areEqual(1, contacts.size(), 'should only be one contact');
    Assert.areEqual(pendingContact.FirstName, contacts[0].FirstName, 'first name of contact should match what was passed in');
    Assert.areEqual(pendingContact.LastName, contacts[0].LastName, 'last name of contact should match what was passed in');
    Assert.areEqual(pendingContact.Email, contacts[0].Email, 'email of contact should match what was passed in');
    Assert.areEqual(1, grantContacts.size(), 'should only be one grant contact');
    Assert.areEqual(contacts[0].Id, grantContacts[0].Grantee__c, 'grantee should match the contact created');
    Assert.areEqual(testGrant.Id, grantContacts[0].Grant__c, 'grant should match the grant created');
  }

  @isTest
  private static void createContact_noAccess() { // NOPMD - ApexUnitTestClassShouldHaveAsserts - Using new Assert class
    Grant__c testGrant = new Grant__c(Name = 'Test Grant');
    insert testGrant;

    Contact pendingContact = new Contact(FirstName = 'First', LastName = 'Last', Email = 'first.last@example.com');

    Boolean exceptionCaught = false;
    System.runAs(TestUtilities.fabricateUser('Chatter Free User')) {
      Test.startTest();
      try {
        QuickContactInputController.createContact(pendingContact, testGrant.Id);
      }
      catch (AuraHandledException aex) {
        exceptionCaught = true;
      }
      Test.stopTest();
    }

    List<Contact> contacts = [SELECT FirstName, LastName, Email FROM Contact];
    List<Grant_Contact__c> grantContacts = [SELECT Grantee__c, Grant__c FROM Grant_Contact__c];

    Assert.areEqual(0, contacts.size(), 'no contact should have been created');
    Assert.areEqual(0, grantContacts.size(), 'no grant contact should have been created');
    Assert.isTrue(exceptionCaught, 'exception should have been thrown');
  }

  @isTest
  private static void createContact_missingContact() { // NOPMD - ApexUnitTestClassShouldHaveAsserts - Using new Assert class
    Grant__c testGrant = new Grant__c(Name = 'Test Grant');
    insert testGrant;

    Boolean exceptionCaught = false;
    Test.startTest();
    try {
      QuickContactInputController.createContact(null, testGrant.Id);
    }
    catch (AuraHandledException aex) {
      exceptionCaught = true;
    }
    Test.stopTest();

    List<Contact> contacts = [SELECT FirstName, LastName, Email FROM Contact];
    List<Grant_Contact__c> grantContacts = [SELECT Grantee__c, Grant__c FROM Grant_Contact__c];

    Assert.areEqual(0, contacts.size(), 'contact should not have been created');
    Assert.areEqual(0, grantContacts.size(), 'no grant contact should have been created');
    Assert.isTrue(exceptionCaught, 'exception should have been thrown');
  }

  @isTest
  private static void createContact_missingGrantId() { // NOPMD - ApexUnitTestClassShouldHaveAsserts - Using new Assert class
    Contact pendingContact = new Contact(FirstName = 'First', LastName = 'Last', Email = 'first.last@example.com');

    Boolean exceptionCaught = false;
    Test.startTest();
    try {
      QuickContactInputController.createContact(pendingContact, null);
    }
    catch (AuraHandledException aex) {
      exceptionCaught = true;
    }
    Test.stopTest();

    List<Contact> contacts = [SELECT FirstName, LastName, Email FROM Contact];
    List<Grant_Contact__c> grantContacts = [SELECT Grantee__c, Grant__c FROM Grant_Contact__c];

    Assert.areEqual(1, contacts.size(), 'one contact should have been created');
    Assert.areEqual(0, grantContacts.size(), 'no grant contact should have been created');
    Assert.isTrue(exceptionCaught, 'exception should have been thrown');
  }
}