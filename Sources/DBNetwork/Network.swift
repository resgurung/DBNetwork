//
//  Network.swift
//  Tests iOS
//
//  Created by Robin Gurung on 10/08/2021.
//

import Foundation
import Combine


public protocol Networkprotocol {
    
    func run(for request: URLRequest) -> URLSession.DataTaskPublisher
    
    func validate(_ data: Data, _ response: URLResponse) throws -> Data
}

public struct Network: Networkprotocol {
    
    var customPublisher: NetworkPublisherProtocol
    
    public init(_ customPublisher: NetworkPublisherProtocol = NetworkDataTaskPublisher()) {
        self.customPublisher = customPublisher
    }
    
    public func run(for request: URLRequest) -> URLSession.DataTaskPublisher {
        return customPublisher.dataTaskPublisher(for: request)
    }
    
    public func validate(_ data: Data, _ response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw DBAPIError.responseNotHTTPURLResponse
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw DBAPIError.statusCode(httpResponse.statusCode)
        }
        return data
    }
}
