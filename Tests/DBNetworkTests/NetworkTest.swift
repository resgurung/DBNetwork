//
//  NetworkTest.swift
//  Tests iOS
//
//  Created by Robin Gurung on 10/08/2021.
//

import XCTest
import Combine

@testable import DBNetwork
class NetworkTest: XCTestCase {
    
    var mockObject: NetworkingObjectMock!
    
    var customPublisher: NetworkPublisherProtocol!
    
    override func setUp() {
        super.setUp()
        
        mockObject = NetworkingObjectMock()
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        
        let session = URLSession(configuration: config)
        customPublisher = NetworkDataTaskPublisher(session)
    }
    
    override func tearDown() {
        
        mockObject = nil
        
        customPublisher = nil
        
        URLProtocolMock.response = nil
        URLProtocolMock.error = nil
        URLProtocolMock.testURLs = [URL?: Data]()
        
        super.tearDown()
    }
    
    func test_getSettingURLRequest() {
        
        guard let urlRequest = try? DBURLRequestBuilder(with: URL(string: mockObject.urlString))
                .set(method: HTTPMethod.get)
                .set(timeoutInterval: mockObject.testTimeout)
                .set(headers: mockObject.defaultHeaders)
                .build()
        else { fatalError("Building URLRequest failed") }
        
        let future: URLSession.DataTaskPublisher =
            Network(customPublisher).run(for: urlRequest)
        
        let request = future.request
        XCTAssertEqual(request.url?.absoluteString, mockObject.urlString)
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?.count, mockObject.defaultHeaders.count)
        XCTAssertEqual(request.httpMethod, HTTPMethod.get.rawValue)
        XCTAssertEqual(request.timeoutInterval, mockObject.testTimeout)
        XCTAssertNil(request.httpBody, "URLRequest body not set on GET Method")
    }
    
    func testValidate() {
        
        let apiRequest = Network(customPublisher)
        XCTAssertThrowsError(try apiRequest.validate(Data(), mockObject.invalidResponse))
        XCTAssertThrowsError(try apiRequest.validate(Data(), mockObject.invalidResponse300!))
        XCTAssertThrowsError(try apiRequest.validate(Data(), mockObject.invalidResponse401!))
        
        let data = try? apiRequest.validate(Data(), mockObject.validResponse!)
        XCTAssertNotNil(data)
    }
}
