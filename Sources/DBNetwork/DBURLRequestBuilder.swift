//
//  DBRequest.swift
//  DBNetwork
//
//  Created by Resham gurung on 07/05/2020.
//  Copyright © 2020 Resham gurung. All rights reserved.
//

import Foundation


public class DBURLRequestBuilder {

    private var url: URL?

    private var method: HTTPMethod = .get
    
    private var parameters: RequestParams?
    
    private var encoder: DBParameterEncoderType?
    
    private var timeoutInterval: TimeInterval = 60
    
    private var headers: [HTTPHeader] = [.accept, .contentType]
    
    private var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    
    private var adapters: [DBURLRequestAdapter] = []
    
    public init(with url: URL?) {
        
        self.url = url
    }
    
    @discardableResult
    public func set(method: HTTPMethod) -> Self {
        
        self.method = method
        
        return self
    }
    

    @discardableResult
    public func set(headers: [HTTPHeader]) -> Self {
        
        self.headers = headers

        return self
    }
    
    @discardableResult
    public func set(parameters: RequestParams?,
             _ encoder: DBParameterEncoderType? = DBJsonParameterEncoder()) -> Self {
        
        self.parameters = parameters
        
        self.encoder = encoder
        
        return self
    }
    
    @discardableResult
    public func set(cachePolicy: URLRequest.CachePolicy) -> Self {
        
        self.cachePolicy = cachePolicy
        
        return self
    }
    
    @discardableResult
    public func set(timeoutInterval: TimeInterval) -> Self {
        
        self.timeoutInterval = timeoutInterval
        
        return self
    }
    
    @discardableResult
    public func set(adapter: DBURLRequestAdapter?) -> Self {
        
        guard let adapter = adapter else { return self }
        
        adapters.append(adapter)
        
        return self
    }
    
    public func build() throws -> URLRequest {
        do {
            
            guard let unwrappedURL = url else {
                
                throw DBAPIError.missingURL
            }
            var urlRequest = URLRequest(url: unwrappedURL,
                                        cachePolicy: cachePolicy,
                                        timeoutInterval: timeoutInterval)
            
            try adapters.forEach {
                urlRequest = try $0.adapt(&urlRequest)
            }
            
            urlRequest.httpMethod = method.rawValue
            
            headers.forEach {
                
                urlRequest.addValue($0.header.1 , forHTTPHeaderField: $0.header.0)
            }
            
            if let params = parameters {
                
                try encoder?.encode(urlRequest: &urlRequest, with: params)
            }
            
            return urlRequest
            
        } catch {
            
            throw DBAPIError.requestBuilderFailure
        }
    }
}
