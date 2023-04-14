public with sharing class QuickContactListController {

  @AuraEnabled(cacheable=true)
  public static List<GrantContact> getGrantContacts(Id grantId){
    List<Grant_Contact__c> grantContacts = new List<Grant_Contact__c>();

    try {
      grantContacts = [SELECT Id, Grantee__r.FirstName, Grantee__r.LastName, Grantee__r.Email, Grant__r.Name FROM Grant_Contact__c WHERE Grant__c = :grantId WITH SECURITY_ENFORCED ORDER BY Grantee__r.LastName];
    }
    catch (Exception ex) {
      throw new AuraHandledException(ex.getMessage());
    }

    List<GrantContact> contacts = new List<GrantContact>();
    for (Grant_Contact__c grantContact : grantContacts) {
      contacts.add(new GrantContact(grantContact));
    }

    return contacts;
  }

  public class GrantContact {
    @AuraEnabled public Id id;
    @AuraEnabled public String firstName;
    @AuraEnabled public String lastName;
    @AuraEnabled public String email;
    @AuraEnabled public Id contactId;
    @AuraEnabled public String contactLink {
      get { return '/' + this.contactId; }
    }

    public GrantContact(Grant_Contact__c grantContact) {
      this.id = grantContact.Id;
      this.firstName = grantContact.Grantee__r.FirstName;
      this.lastName = grantContact.Grantee__r.LastName;
      this.email = grantContact.Grantee__r.Email;
      this.contactId = grantContact.Grantee__c;
    }
  }
}