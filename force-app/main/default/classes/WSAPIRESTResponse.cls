/*********************************************************************************************************
* Class Name: WSAPIRESTResponse 
* Description: Standard REST Response for REST Services
*********************************************************************************************************/

global class WSAPIRESTResponse{

    global Boolean isSuccess {get; set;}
    global String message {get; set;}
    global Object data {get;set;}

}