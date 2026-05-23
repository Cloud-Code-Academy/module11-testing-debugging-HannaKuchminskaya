
@isTest
public class LeadTriggerHandlerTest {

    @isTest
   public static void handleTitleNormalizationCorrectionUnitTest() {
    List<Lead> leads = new List<Lead>();
    for (Integer i = 0; i < 200; i++) {
        Lead lead = new Lead();
        lead.FirstName = 'Name ' + i;
        lead.LastName = 'Last Name ' + i;
        lead.Company = 'Company ' + i;
        leads.add(lead);
    }
    leads[0].Title = 'vp';
    leads[1].Title = 'v.p.';
    leads[2].Title = 'mgr';
    leads[3].Title = 'manage';
    leads[4].Title = 'head of department';
    leads[5].Title = 'exec';
    leads[6].Title = 'chief';
    leads[7].Title = 'head';
    leads[8].Title = 'assist';
    leads[9].Title = 'deputy';
    insert leads;

    Test.startTest();
    LeadTriggerHandler.handleTitleNormalization(leads);
    Test.stopTest();
    List<Lead> insertedVpLeads = [SELECT Id, Title FROM Lead WHERE LastName = 'Last Name 0' LIMIT 1];
    Assert.areEqual('Vice President', insertedVpLeads[0].Title, 'The title should be normalized to \'Vice President\'');
    List<Lead> insertedVPwithDotsLeads = [SELECT Id, Title FROM Lead WHERE LastName = 'Last Name 1' LIMIT 1];
    Assert.areEqual('Vice President', insertedVPwithDotsLeads[0].Title, 'The title should be normalized to \'Vice President\'');
    List<Lead> insertedMGRLeads = [SELECT Id, Title FROM Lead WHERE LastName = 'Last Name 2' LIMIT 1];
    Assert.areEqual('Manager', insertedMGRLeads[0].Title, 'The title should be normalized to \'Manager\'');
    List<Lead> insertedManageLeads = [SELECT Id, Title FROM Lead WHERE LastName = 'Last Name 3' LIMIT 1];
    Assert.areEqual('Manager', insertedManageLeads[0].Title, 'The title should be normalized to \'Manager\'');  
    List<Lead> insertedHeadOfDepartmentLeads = [SELECT Id, Title FROM Lead WHERE LastName = 'Last Name 4' LIMIT 1];
    Assert.areEqual('Manager', insertedHeadOfDepartmentLeads[0].Title, 'The title should be normalized to \'Manager\'');  
    List<Lead> insertedExecLeads = [SELECT Id, Title FROM Lead WHERE LastName = 'Last Name 5' LIMIT 1];
    Assert.areEqual('Executive', insertedExecLeads[0].Title, 'The title should be normalized to \'Executive\''); 
    List<Lead> insertedChiefLeads = [SELECT Id, Title FROM Lead WHERE LastName = 'Last Name 6' LIMIT 1];
    Assert.areEqual('Executive', insertedChiefLeads[0].Title, 'The title should be normalized to \'Executive\''); 
    List<Lead> insertedHeadLeads = [SELECT Id, Title FROM Lead WHERE LastName = 'Last Name 7' LIMIT 1];
    Assert.areEqual('Executive', insertedHeadLeads[0].Title, 'The title should be normalized to \'Executive\''); 
    List<Lead> insertedAssistLeads = [SELECT Id, Title FROM Lead WHERE LastName = 'Last Name 8' LIMIT 1];
    Assert.areEqual('Assistant', insertedAssistLeads[0].Title, 'The title should be normalized to \'Assistant\''); 
    List<Lead> insertedDeputyLeads = [SELECT Id, Title FROM Lead WHERE LastName = 'Last Name 9' LIMIT 1];
    Assert.areEqual('Assistant', insertedDeputyLeads[0].Title, 'The title should be normalized to \'Assistant\''); 

   }

   @isTest
public static void handleTitleNormalizationNoCorrectionUnitTest(){
     List<Lead> leads = new List<Lead>();
    for (Integer i = 0; i < 200; i++) {
        Lead lead = new Lead();
        lead.FirstName = 'Name ' + i;
        lead.LastName = 'Last Name ' + i;
        lead.Company = 'Company ' + i;
        leads.add(lead);
    }
    leads[0].Title = 'chef';
    leads[1].Title = 'test';
    leads[2].Title = 'admin';
    leads[3].Title = 'director';
    insert leads;

    Test.startTest();
    LeadTriggerHandler.handleTitleNormalization(leads);
    Test.stopTest();
    List<Lead> insertedChefLeads = [SELECT Id, Title FROM Lead WHERE LastName = 'Last Name 0' LIMIT 1];
    Assert.areEqual('chef', insertedChefLeads[0].Title, 'The title should be \'chef\'');
    List<Lead> insertedTestLeads = [SELECT Id, Title FROM Lead WHERE LastName = 'Last Name 1' LIMIT 1];
    Assert.areEqual('test', insertedTestLeads[0].Title, 'The title should be \'test\'');
    List<Lead> insertedAdminLeads = [SELECT Id, Title FROM Lead WHERE LastName = 'Last Name 2' LIMIT 1];
    Assert.areEqual('admin', insertedAdminLeads[0].Title, 'The title should be \'admin\'');
    List<Lead> insertedDirectorLeads = [SELECT Id, Title FROM Lead WHERE LastName = 'Last Name 3' LIMIT 1];
    Assert.areEqual('director', insertedDirectorLeads[0].Title, 'The title should be normalized to \'Director\'');  
    }

    @IsTest
    public static void handleAutoLeadScoringUpdateScoreUnitTest(){


    List<Lead> leads = new List<Lead>();
    for (Integer i = 0; i < 200; i++) {
        Lead lead = new Lead();
        lead.FirstName = 'Name ' + i;
        lead.LastName = 'Last Name ' + i;
        lead.Company = 'Company ' + i;
        leads.add(lead);
    }
    leads[0].Phone = '123456789';
    leads[1].Industry = 'Technology';  leads[1].Phone = '777777777'; 
    leads[2].LeadSource = 'Web'; leads[2].Email = 'testleademail123@gmail.com'; leads[2].Phone = '555555555';leads[2].Industry = 'Technology';
    insert leads;

    Test.startTest();
    LeadTriggerHandler.handleAutoLeadScoring(leads);
    Test.stopTest();
    List<Lead> insertedPhoneLeads = [SELECT Id, Lead_Score__c FROM Lead WHERE LastName = 'Last Name 0' LIMIT 1];
    Assert.areEqual(5, insertedPhoneLeads[0].Lead_Score__c, 'The score should be 5');
    List<Lead> insertedPhoneIndustryLeads = [SELECT Id, Lead_Score__c FROM Lead WHERE LastName = 'Last Name 1' LIMIT 1];
    Assert.areEqual(15, insertedPhoneIndustryLeads[0].Lead_Score__c, 'The score should be 15');
    List<Lead> insertedMaxScoreLeads = [SELECT Id, Lead_Score__c FROM Lead WHERE LastName = 'Last Name 2' LIMIT 1];
    Assert.areEqual(18, insertedMaxScoreLeads[0].Lead_Score__c, 'The score should be 18');
    }

    @IsTest
    public static void handleAutoLeadScoringNoUpdateScoreUnitTest(){


    List<Lead> leads = new List<Lead>();
    for (Integer i = 0; i < 200; i++) {
        Lead lead = new Lead();
        lead.FirstName = 'Name ' + i;
        lead.LastName = 'Last Name ' + i;
        lead.Company = 'Company ' + i;
        leads.add(lead);
    }
    leads[0].LeadSource = 'Web'; 
    insert leads;

    Test.startTest();
    LeadTriggerHandler.handleAutoLeadScoring(leads);
    Test.stopTest();
    List<Lead> insertedWebOnlyLeads = [SELECT Id, Lead_Score__c FROM Lead WHERE LastName = 'Last Name 0' LIMIT 1];
    Assert.areEqual(0, insertedWebOnlyLeads[0].Lead_Score__c, 'The score should be 0');
    List<Lead> insertedNoScoreLeads = [SELECT Id, Lead_Score__c FROM Lead WHERE LastName = 'Last Name 1' LIMIT 1];
    Assert.areEqual(0, insertedNoScoreLeads[0].Lead_Score__c, 'The score should be 0');
    }

@isTest
public static void handleLeadAutoConvertOneMatchUnitTest () {
    Account acc = new Account();
    acc.Name = 'TestLeadAutoConvert';
    insert acc;

    contact contact = new Contact ();
    contact.FirstName = 'Hanna';
    contact.LastName = 'Test';
    contact.Email = 'hannatest@gmail.com';
    contact.AccountId = acc.Id;
    insert contact;

    lead lead = new Lead ();
    lead.FirstName = 'Hanna';
    lead.LastName = 'Test';
    lead.Company = 'TestLeadAutoConvert';
    lead.Email = 'hannatest@gmail.com';

    Test.startTest();
    insert lead;
    Test.stopTest();

    Lead convertedLead = [SELECT Id, FirstName, LastName, Email, isConverted, ConvertedContactId, ConvertedAccountId 
                        FROM Lead WHERE email = 'hannatest@gmail.com' AND isConverted = true];
    Assert.areEqual(convertedLead.ConvertedContactId, contact.Id, 'The contact Id should be the same');
    Assert.areEqual(convertedLead.ConvertedAccountId, acc.Id, 'The account Id should be the same');
}
@isTest
public static void handleLeadAutoConvertMultipleMatchUnitTest () {
    Account acc = new Account();
    acc.Name = 'TestLeadAutoConvert';
    insert acc;

    contact contact1 = new Contact ();
    contact1.FirstName = 'Hanna';
    contact1.LastName = 'Test';
    contact1.Email = 'hannatest@gmail.com';
    contact1.AccountId = acc.Id;
    insert contact1;

    contact contact2 = new Contact ();
    contact2.FirstName = 'Hanna1';
    contact2.LastName = 'Test';
    contact2.Email = 'hannatest@gmail.com';
    contact2.AccountId = acc.Id;
    insert contact2;

    lead lead = new Lead ();
    lead.FirstName = 'Hanna';
    lead.LastName = 'Test';
    lead.Company = 'TestLeadAutoConvert';
    lead.Email = 'hannatest@gmail.com';

    Test.startTest();
    insert lead;
    Test.stopTest();

    Lead nonConvertedLead = [SELECT Id, FirstName, LastName, Email, isConverted, ConvertedContactId, ConvertedAccountId 
                        FROM Lead WHERE email = 'hannatest@gmail.com' AND isConverted = false];
    Assert.areEqual(nonConvertedLead.ConvertedContactId, null, 'The contact Id should be null');
    Assert.areEqual(nonConvertedLead.ConvertedAccountId, null, 'The account Id should be null');
    Assert.areEqual(nonConvertedLead.IsConverted, false, 'The lead should not be converted');
}

}
