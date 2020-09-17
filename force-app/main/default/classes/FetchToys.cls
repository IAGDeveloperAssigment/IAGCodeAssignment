/*********************************************************************************************************
* Class Name: FetchToys 
* Description: Get Toys List based on the Name.
*********************************************************************************************************/
@RestResource(urlMapping='/fetchToys/*')
//url=/services/apexrest/fetchToys/
global with sharing class FetchToys extends WSRESTBase{
    public class FetchToysResponse {
		public String name {get;set;}
		public String description {get;set;}
        public Boolean isAvailable {get;set;}
        public Decimal price {get;set;}

		public FetchToysResponse(String name, String description, Boolean isAvailable,Decimal price) {
            this.name = name;
			this.description = description;
            this.isAvailable = isAvailable;
            this.price=price;
        }
	}
    @HttpPost
    global static void findToys(){
        WSRESTBase base = new WSRESTBase();
        try{
            String jsonRequest = RestContext.request.requestBody.toString();
            if(!String.isEmpty(jsonRequest) && jsonRequest!='{}'){
               Map<String,List<String>> toyNamesMap = (Map<String,List<String>>)JSON.deserialize(jsonRequest, Map<String,List<String>>.class);
                List<String> toyNames=new List<String>();
                For(String name :toyNamesMap.keySet()){
                    toyNames.addAll(toyNamesMap.get(name));
                }  
                Map<String,Toys__c> resultMap = new Map<String,Toys__c>();
                for (toys__c toys :[select name,description__c,price__c,is_available__c from Toys__c where Name IN :toyNames]){
                    resultMap.put(toys.name,toys);
                }
                List<FetchToysResponse> foundRecords = new List<FetchToysResponse>();
                List<String> notFoundRecords = new List<String>();
                Map<String,Object> responseMap = new Map<String,Object>();
                if(!resultMap.isempty()){
                    for(String toyName :toyNames){
                        if(resultMap.containsKey(toyName)){
                            Toys__c toyRec = resultMap.get(toyName);
                            FetchToysResponse toyResp = new FetchToysResponse(toyRec.name,toyRec.description__c,toyRec.is_available__c,toyRec.price__c);
                            foundRecords.add(toyResp);
                            responseMap.put(WSRESTBase.REST_MSG_DATA_FOUND,foundRecords);
                        }
                        else{
                            notFoundRecords.add(toyName);
                            responseMap.put(WSRESTBase.REST_MSG_DATA_NOT_FOUND,notFoundRecords);
                        }
                    }
                    base.setResponse(200, true, null,responseMap,null,null);
                                    
                }
                else{
                    base.setDataNotFound(jsonRequest);
                }
            }
            else{
                    base.setInvalidRequest(jsonRequest);
                }
        }
        catch(Exception exp){           
            logMessage(LoggingLevel.DEBUG,'** exp ==>'+ exp.getStackTraceString());
            base.setResponse(400,false,null,null,null,exp);
        }
    }
}