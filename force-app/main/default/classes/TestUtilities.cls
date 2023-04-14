@isTest
public with sharing class TestUtilities {
  public static User fabricateUser(String profileName) {
    User user = new User(
      ProfileId = [SELECT Id FROM Profile WHERE Name = :profileName].Id,
      LastName = 'last',
      Email = 'peter.griffin@example.com',
      UserName = 'peter.griffin.' + DateTime.now().getTime() + '@example.com',
      Alias = 'alias',
      TimeZoneSidKey = 'America/Los_Angeles',
      EmailEncodingKey = 'UTF-8',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US'
    );

    return user;
  }
}