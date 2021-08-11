import Foundation


//This defines the type of HTTP method used to perform the request
public enum HTTPMethod: String {
    
    case post   = "POST"
    
    case put    = "PUT"
    
    case get    = "GET"
    
    case delete = "DELETE"
    
    case patch  = "PATCH"
}

// Headers
public typealias HTTPHeaders = [String : Any]

public typealias RequestParams = [String: Any]

public typealias HTTPHeaderKey     = String
public typealias HTTPHeaderValue   = String

public enum HTTPHeader {
    
    case accept
    
    case contentType
    
    case cacheControl
    
    case contentTypeURLFormEncoded
    
    case tokenAuthorization( HTTPHeaderValue )
    
    case bearerAuthorization( HTTPHeaderValue )
    
    case custom( HTTPHeaderKey, HTTPHeaderValue )
    
    public var header: ( HTTPHeaderKey , HTTPHeaderValue ) {
        
        switch self {
            
        case .accept:
            
            return ( "Accept" , "application/json" )
            
        case .contentType:
            
            return ( "Content-Type" , "application/json" )
            
        case .cacheControl:
            
            return ( "Cache-Control", "no-cache" )
            
        case .contentTypeURLFormEncoded:
            
            return ( "Content-Type" , "application/x-www-form-urlencoded" )
            
        case .tokenAuthorization( let token):
            
            return ( "Authorization" , "Token \(token)" )
            
        case .bearerAuthorization( let bearer ):
            
            return ( "Authorization" , "Bearer \(bearer)" )
            
        case .custom( let key, let value ):
            
            return ( key , value )
        }
    }
    
}


