/*********************************************************************************************************
* Class Name: getToys 
* Description: Get Toys List based on the Name.
*********************************************************************************************************/
@RestResource(urlMapping='/retrieveToys/*')
global without sharing class getToys extends WSRESTBase{
    public static final String REST_MSG_DATA_FOUND = 'Match Found';
    public static final String REST_MSG_DATA_NOT_FOUND = 'no toy match found';
    @HttpPost
    global static void findToys(){
        WSRESTBase base = new WSRESTBase();
        try{
            String jsonRequest = RestContext.request.requestBody.toString();
            if(String.isNotEmpty(jsonRequest)){
               Map<String,List<String>> toyNamesMap = (Map<String,List<String>>)JSON.deserialize(jsonRequest, Map<String,List<String>>.class);
                List<String> toyNames=new List<String>();
                For(String name :toyNamesMap.keySet()){
                    toyNames.addAll(toyNamesMap.get(name));
                }  
                Map<String,Toys__c> resultMap = new Map<String,Toys__c>();
                for (toys__c toys :[select name,description__c,price__c,is_available__c from Toys__c where Name IN :toyNames]){
                    resultMap.put(toys.name,toys);
                }
                system.debug('@@@1' +resultMap);
                List<Toys__c> foundRecords = new List<Toys__c>();
                List<String> notFoundRecords = new List<String>();
                Map<String,Object> responseMap = new Map<String,Object>();
                if(!resultMap.isempty()){
                    for(String toyName :toyNames){
                        if(resultMap.containsKey(toyName)){
                            foundRecords.add(resultMap.get(toyName));
                            responseMap.put(REST_MSG_DATA_FOUND,foundRecords);
                           //base.setResponse(200, true, resultMap.get(toyName),null,null); 
                        }
                        else{
                            notFoundRecords.add(toyName);
                            responseMap.put(REST_MSG_DATA_NOT_FOUND,notFoundRecords);
                            //base.setDataNotFound(toyName);
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