import Foundation

/// Error for Session, Request
public enum DBAPIError: Error {
    
    case requestFailure
    
    case requestBuilderFailure
    
    case jsonConversionFailure
    
    case invalidDataFailure
    
    case responseUnsuccessfulFailure
    
    case jsonParsingFailure
    
    case parameterNilFailure
    
    case encodingFailure
    
    case requestBadInput
    
    case missingURL
    
    case missingURLRequest
    
    case encodingFail
    
    case notSerializable
    
    case unacceptableStatusCode(Int)
    
    case unexpectedResponse(Any)
    
    case refreshToken
    
    case emptyResponse
    
    case error_304(Any)
    
    case responseNotHTTPURLResponse
    
    case zeroByteResource
    
    case statusCode(Int)
    
}

extension DBAPIError: LocalizedError{
    
    public var errorDescription: String? {
        
        switch self {
            
        case .requestFailure:
            
            return NSLocalizedString("Request Failed.", comment: "Error")
        
        case .requestBuilderFailure:
            
            return NSLocalizedString("Request builder Failed.", comment: "Error")
            
        case .invalidDataFailure:
            
            return NSLocalizedString("Invalid Data.", comment: "Error")
            
        case .responseUnsuccessfulFailure:
            
            return NSLocalizedString("Response Unsuccessful.", comment: "Error")
            
        case .jsonParsingFailure:
            
            return NSLocalizedString("JSON Parsing Failure.", comment: "Error")
            
        case .jsonConversionFailure:
            
            return NSLocalizedString("JSON Conversion Failure.", comment: "Error")
            
        case .parameterNilFailure:
            
            return NSLocalizedString("Parameter were nil.", comment: "Error")
            
        case .encodingFailure:
            
            return NSLocalizedString("Parameter encoding failed.", comment: "Error")
            
        case .requestBadInput:
            
            return NSLocalizedString("Request malformed.", comment: "Error")
            
        case .missingURL:
            
            return NSLocalizedString("URL not found.", comment: "Error")
            
        case .missingURLRequest:
            
            return NSLocalizedString("URLRequest not found.", comment: "Error")
        
        case .encodingFail:
            
            return NSLocalizedString("Parameters encoding fails", comment: "Error")
        
        case .notSerializable:
            
            return NSLocalizedString("Parameters cannot be serialize.", comment: "Error")
            
        case .refreshToken:
            
            return NSLocalizedString("Refresh token.", comment: "Token Error")
            
        case .unacceptableStatusCode(let code):
                
                return NSLocalizedString("Error code: \(code)", comment: "Error")

        case .unexpectedResponse(let error):
            
            return NSLocalizedString((error as? Error)?.localizedDescription ?? "Unknown error, we are working on it.", comment: "Error")
            
        case .emptyResponse:
            
            return  NSLocalizedString("The response is empty.", comment: "NetworkError")
            
        case .error_304(let error):
            
            return NSLocalizedString((error as? Error)?.localizedDescription ?? "Data Not changed.", comment: "Error")
            
        case .responseNotHTTPURLResponse:
            
            return NSLocalizedString("The response is not a HTTPURLResponse.", comment: "NetworkError")
            
        case .zeroByteResource:
            
            return NSLocalizedString("Empty data.", comment: "Error")
            
        case .statusCode(let statusCode):
        
            let message = HTTPURLResponse.localizedString(forStatusCode: statusCode)
            
            return NSLocalizedString("Code: \(statusCode), Message: \(message)", comment: "NetworkError")
        }
    }
}
