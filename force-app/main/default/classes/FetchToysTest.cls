/*********************************************************************************************************
* Class Name: FetchToysTest 
* Test Class for FetchToys
*********************************************************************************************************/

@isTest
public class FetchToysTest {

    @isTest
    static void testFindToys() {
        List<Toys__c> toys = new List<Toys__c>();
        Toys__c toy1 = new Toys__c();
        toy1.name='xyz';
        toy1.description__c='test';
        toy1.is_available__c=true;
        toy1.price__c = 30.8;
        toys.add(toy1);

        Toys__c toy2 = new Toys__c();
        toy2.name='abc';
        toy2.description__c='test123';
        toy2.is_available__c=false;
        toy2.price__c = 100;
        toys.add(toy2);
        insert toys;

        Test.startTest();
        RestRequest request = new RestRequest();
		RestResponse response = new RestResponse();
        request.requestBody = Blob.valueOf('{"Name":["xyz","abc","123"]}');
		request.httpMethod = 'POST';
        request.headers.put('Content-Type', 'application/json');		
		RestContext.request = request;
        RestContext.response = response;
        FetchToys.findToys();
        String actualValue = response.responseBody.toString();
        System.assertEquals(200, response.statusCode);
        System.assert(actualValue.contains('"isSuccess":true'), actualValue);
        request.requestBody = Blob.valueOf('{"Name":["xyr","abci","123"]}');
        FetchToys.findToys();
        String actualValue1 = response.responseBody.toString();
        System.assertEquals(200, response.statusCode);
        System.assert(actualValue1.contains('"isSuccess":false'), actualValue1);
        System.assert(actualValue1.contains('"message":"No Toy Match Found"'),actualValue1);
        request.requestBody = Blob.valueOf('{}');
        FetchToys.findToys();
        String actualValue2 = response.responseBody.toString();
        System.assertEquals(200, response.statusCode);
        System.assert(actualValue2.contains('"isSuccess":false'), actualValue2);
        System.assert(actualValue2.contains('"message":"Invalid Request"'),actualValue2);

        Test.stopTest();

    }

    @isTest
    static void testFindToysException() {

        Test.startTest();
        RestRequest request = new RestRequest();
		RestResponse response = new RestResponse();
		request.httpMethod = 'POST';
        request.headers.put('Content-Type', 'application/json');
		
		RestContext.request = request;
		RestContext.response = response;

		FetchToys.findToys();

        String contentType = response.headers.get('Content-Type');
		String actualValue = response.responseBody.toString();
		System.assertEquals(400, response.statusCode);
		System.assert(actualValue.contains('"isSuccess":false'), actualValue);
        
        Test.stopTest();

    }

}