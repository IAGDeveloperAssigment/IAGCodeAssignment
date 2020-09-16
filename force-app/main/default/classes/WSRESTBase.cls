/*********************************************************************************************************
* Class Name: WSRESTBase 
* Description: Base class for REST services
*********************************************************************************************************/
public virtual class WSRESTBase {

    // constants
    public static final String REST_MSG_DATA_FOUND = 'Match Found';
    public static final String REST_MSG_INVALID_REQUEST = 'Invalid Request';
    public static final String REST_MSG_DATA_NOT_FOUND = 'no toy match found';

    // variables
    private RestRequest apiRequest {get;set;}
    private RestResponse apiResponse {get;set;}

    public WSRESTBase(){
        apiRequest = RestContext.request;
        apiResponse = RestContext.response;
    }

   
    // set invalid request for the call
    public virtual void setInvalidRequest(String reqInfo){
        setResponse(200,false,reqInfo,null,REST_MSG_INVALID_REQUEST,null);
    }

    // set data not found
    public virtual void setDataNotFound(String reqInfo){
        setResponse(200,false,reqInfo,null,REST_MSG_DATA_NOT_FOUND,null);
    }

    // Set JSON Response for the service
    public virtual void setResponse(Integer statusCode,Boolean isSuccess,Object data,Map<String,Object> respMap,String Message,Exception exp){
        List<WSAPIRESTResponse> responses = new List<WSAPIRESTResponse>();
        
        List<Object> objList = new List<Object>();
        List<String> msgs = new List<String>();
        if(!respMap.isEmpty()){
            WSAPIRESTResponse resp = new WSAPIRESTResponse();
            if(respMap.containsKey(REST_MSG_DATA_NOT_FOUND)){
                resp.data=respMap.get(REST_MSG_DATA_NOT_FOUND);
                resp.message=REST_MSG_DATA_NOT_FOUND;
                resp.isSuccess = isSuccess;
                responses.add(resp);
            }
            if(respMap.containsKey(REST_MSG_DATA_FOUND)){
               resp.data=respMap.get(REST_MSG_DATA_FOUND);
               resp.message=REST_MSG_DATA_FOUND;
               resp.isSuccess = isSuccess;
               responses.add(resp);
                
            }
            setResponse(statusCode,responses);
        }
        else {
            WSAPIRESTResponse response = new WSAPIRESTResponse();
            response.isSuccess = isSuccess;
        	response.data = data;
            if(!String.isEmpty(Message)){
                response.message = message;
            }   
            if(exp != null){
                response.message=exp.getMessage();
            }
            setResponse(statusCode,response);
        }
    }

    // Set JSON Response for the service
    public virtual void setResponse(Integer statusCode,Object responseBody){
        logMessage(LoggingLevel.DEBUG,responseBody);
        apiResponse.statusCode = statusCode;
        String jsonBody = JSON.serialize(responseBody);
        logMessage(LoggingLevel.DEBUG,jsonBody);
        apiResponse.responseBody = Blob.valueOf(jsonBody);
    }

    // logs the message during transaction
    public static void logMessage(LoggingLevel logLevel,Object message){
        System.debug(logLevel,'** ' + logLevel + ' : message : '+ message);
    }
}