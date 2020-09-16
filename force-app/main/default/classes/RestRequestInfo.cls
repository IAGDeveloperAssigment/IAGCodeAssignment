/*********************************************************************************************************
* Class Name: RestRequestInfo 
* Description: Request info holder for REST services
*********************************************************************************************************/
public virtual class RestRequestInfo{

    // constants
    public static final String FORWARD_SLASH = '/';

    // variables
    public String baseResource {get; set;}
    public Map<Integer, String> resourceIndexValueMap {get; set;}
    public Map<String, String> requestParamsMap {get; set;}
    public String requestBody {get;set;}
        
    public RestRequestInfo(String baseResource) {
        this.baseResource = baseResource;
        this.resourceIndexValueMap = new Map<Integer, String>();
        this.requestParamsMap = new Map<String, String>();
    }
    
    // parse the request
    public static RestRequestInfo parse(String baseResource,RestRequest apiRequest){
        RestRequestInfo reqInfo = new RestRequestInfo(baseResource);
        if(String.isNotEmpty(baseResource) || String.isNotEmpty(apiRequest.requestURI)){
            reqInfo.requestParamsMap = apiRequest.params;
            reqInfo.resourceIndexValueMap = fetchResourceIndexValueMap(apiRequest.requestURI,baseResource);
            reqInfo.requestBody = apiRequest.requestBody.toString();
        }
        return reqInfo;
    }

    // fetch index & the value in the request
    private static Map<Integer,String> fetchResourceIndexValueMap(String requestURI, String baseResource){
        Map<Integer,String> resourceIndexValueMap = new Map<Integer,String>();

        String extendedResource = requestURI.substringAfter(baseResource.toLowerCase());

        if(String.isNotEmpty(extendedResource) && extendedResource.startsWith(FORWARD_SLASH)){
            Integer resourceIndex = 0;
            while(extendedResource.length() > 0){
                extendedResource = extendedResource.substringAfter(FORWARD_SLASH);
                String resourceValue = extendedResource.substringBefore(FORWARD_SLASH);
                if(String.isNotEmpty(resourceValue)){
                    resourceIndexValueMap.put(resourceIndex,resourceValue);
                    resourceIndex++;
                }
                
                extendedResource = extendedResource.substringAfter(resourceValue);
            }
        }
        return resourceIndexValueMap;
    }
}