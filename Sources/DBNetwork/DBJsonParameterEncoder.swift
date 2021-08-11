//
//  DBJsonParameterEncoder.swift
//  DBNetwork
//
//  Created by Resham gurung on 07/05/2020.
//  Copyright © 2020 Resham gurung. All rights reserved.
//

import Foundation

public protocol DBParameterEncoderType {
    
    func encode(urlRequest: inout URLRequest, with parameters: RequestParams) throws
}

public struct DBJsonParameterEncoder: DBParameterEncoderType {
    
    public init(){ }
    
    public func encode(urlRequest: inout URLRequest, with parameters: RequestParams) throws {
        
        guard JSONSerialization.isValidJSONObject(parameters) else {
            
            throw DBAPIError.notSerializable
        }
        
        urlRequest.httpBody = try serialize(parameters)
        
    }
    
    public func serialize(_ parameters: RequestParams) throws  -> Data {
        
        do {
            
            return try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            
        }catch {
            
            throw DBAPIError.encodingFail
        }
    }
}
