//
//  DBURLRequestBuilderTest.swift
//  Tests iOS
//
//  Created by Robin Gurung on 10/08/2021.
//

import XCTest

@testable import DBNetwork
class DBURLRequestBuilderTest: XCTestCase {
    
    var mockObject: NetworkingObjectMock!
    
    override func setUp() {
        super.setUp()
        
        mockObject = NetworkingObjectMock()
    }
    
    override func tearDown() {
        
        mockObject = nil
        
        super.tearDown()
    }
    
    func test_URL() {
        
        guard let urlRequest = try? DBURLRequestBuilder(with: URL(string: mockObject.urlString))
                .build()
        else { fatalError("Building URLRequest failed") }
        
        XCTAssertEqual(urlRequest.url?.absoluteString, mockObject.urlString)
    }
    
    func test_defaultHeader() {
        
        guard let urlRequest = try? DBURLRequestBuilder(with: URL(string: mockObject.urlString))
                .set(headers: mockObject.defaultHeaders)
                .build()
        else { fatalError("Building URLRequest failed") }
        
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?.count, mockObject.defaultHeaders.count)
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Content-Type"], HTTPHeader.contentType.header.1)
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Cache-Control"], HTTPHeader.cacheControl.header.1)
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Accept"], HTTPHeader.accept.header.1)
    }
    
    func test_URLRequestMethod() {
        
        guard let urlRequest = try? DBURLRequestBuilder(with: URL(string: mockObject.urlString))
                .set(method: HTTPMethod.get)
                .build()
        else { fatalError("Building URLRequest failed") }
        XCTAssertEqual(urlRequest.httpMethod, HTTPMethod.get.rawValue)
    }
    
    func test_URLRequestTimeOut() {
        
        guard let urlRequest = try? DBURLRequestBuilder(with: URL(string: mockObject.urlString))
                .set(timeoutInterval: mockObject.testTimeout)
                .build()
        else { fatalError("Building URLRequest failed") }
        XCTAssertEqual(urlRequest.timeoutInterval, mockObject.testTimeout)
    }
    
    func test_URLRequestBodyNil() {
        guard let urlRequest = try? DBURLRequestBuilder(with: URL(string: mockObject.urlString))
                .build()
        else { fatalError("Building URLRequest failed") }
        
        XCTAssertNil(urlRequest.httpBody, "URLRequest body not set on GET Method")
    }

}
