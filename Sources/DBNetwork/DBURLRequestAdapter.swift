import Foundation


public protocol DBURLRequestAdapter {
    
    func adapt(_ urlRequest: inout URLRequest) throws -> URLRequest
}
