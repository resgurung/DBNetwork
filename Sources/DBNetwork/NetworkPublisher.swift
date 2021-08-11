//
//  NetworkPublisher.swift
//  Tests iOS
//
//  Created by Robin Gurung on 10/08/2021.
//

import Foundation


public protocol NetworkPublisherProtocol {
        
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
}

public class NetworkDataTaskPublisher: NetworkPublisherProtocol {
    
    var session: URLSession
    
    public init(_ session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    public func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher {
        return session.dataTaskPublisher(for: request)
    }
    
}
