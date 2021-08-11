//
//  APIRequestTest.swift
//  Tests iOS
//
//  Created by Robin Gurung on 11/08/2021.
//

import Foundation
import Combine
import XCTest

@testable import DBNetwork
class APIRequestSettingsTest: XCTestCase {

    var mockObject: NetworkingObjectMock!
    
    var customPublisher: NetworkPublisherProtocol!
    
    var apiRequest: AnyAPIRequest<Settings>!
    
    override func setUp() {
        super.setUp()
        
        mockObject = NetworkingObjectMock()
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        
        let session = URLSession(configuration: config)
        customPublisher = NetworkDataTaskPublisher(session)
        
        let network = Network(customPublisher)
        apiRequest = AnyAPIRequest(network)
    }
    
    override func tearDown() {
        
        mockObject = nil
        
        customPublisher = nil
        apiRequest = nil
        
        URLProtocolMock.response = nil
        URLProtocolMock.error = nil
        URLProtocolMock.testURLs = [URL?: Data]()
        
        super.tearDown()
    }
    
    func test_validResponse() {
        
        // set up
        guard let urlRequest = try? DBURLRequestBuilder(with: URL(string: mockObject.urlString))
                .set(method: HTTPMethod.get)
                .set(timeoutInterval: mockObject.testTimeout)
                .set(headers: mockObject.defaultHeaders)
                .build()
        else { fatalError("Building URLRequest failed") }
        
        URLProtocolMock.testURLs = [URL(string: mockObject.urlString): Data(mockObject.settingsJsonResponse.utf8)]
        
        // when is valid
        URLProtocolMock.response = mockObject.validResponse
        //let pub = apiRequest.getData(for: urlRequest)
        let publisher: AnyPublisher<Settings, Error> = apiRequest.getData(for: urlRequest)
        let validTest = evalValidResponseTest(publisher: publisher)
        wait(for: validTest.expectations, timeout: mockObject.testTimeout)
        validTest.cancellable?.cancel()
        
    }
    
    func test_invalidResponse() {
        
        guard let urlRequest = try? DBURLRequestBuilder(with: URL(string: mockObject.urlString))
                .set(method: HTTPMethod.get)
                .set(timeoutInterval: mockObject.testTimeout)
                .set(headers: mockObject.defaultHeaders)
                .build()
        else { fatalError("Building URLRequest failed") }
        // when has invalid response
        URLProtocolMock.response = mockObject.invalidResponse
        let publisher: AnyPublisher<Settings, Error> = apiRequest.getData(for: urlRequest)
        let invalidTest = evalInvalidResponseTest(publisher: publisher)
        wait(for: invalidTest.expectations, timeout: mockObject.testTimeout)
        invalidTest.cancellable?.cancel()
    }
    
    func test_invalidDataButValidResponse() {
        
        guard let urlRequest = try? DBURLRequestBuilder(with: URL(string: mockObject.urlString))
                .set(method: HTTPMethod.get)
                .set(timeoutInterval: mockObject.testTimeout)
                .set(headers: mockObject.defaultHeaders)
                .build()
        else { fatalError("Building URLRequest failed") }
        // when invalid data but valid response
        URLProtocolMock.testURLs[URL(string: mockObject.urlString)] = Data("{{}".utf8)
        URLProtocolMock.response = mockObject.validResponse
        let publisher: AnyPublisher<Settings, Error> = apiRequest.getData(for: urlRequest)
        let invalidTest = evalInvalidResponseTest(publisher: publisher)
        wait(for: invalidTest.expectations, timeout: mockObject.testTimeout)
        invalidTest.cancellable?.cancel()
    }

    func test_networkFailure() {
        
        guard let urlRequest = try? DBURLRequestBuilder(with: URL(string: mockObject.urlString))
                .set(method: HTTPMethod.get)
                .set(timeoutInterval: mockObject.testTimeout)
                .set(headers: mockObject.defaultHeaders)
                .build()
        else { fatalError("Building URLRequest failed") }
        // Network Failure
        URLProtocolMock.response = mockObject.validResponse
        URLProtocolMock.error = mockObject.networkError
        let publisher: AnyPublisher<Settings, Error> = apiRequest.getData(for: urlRequest)
        let invalidTest = evalInvalidResponseTest(publisher: publisher)
        wait(for: invalidTest.expectations, timeout: mockObject.testTimeout)
        invalidTest.cancellable?.cancel()
    }
    
    func test_decodedData() {
        
        let expectationFinished = expectation(description: "finished")
        let expectationReceive = expectation(description: "receiveValue")
        let expectationFailure = expectation(description: "failure")
        expectationFailure.isInverted = true
        
        // set up
        guard let urlRequest = try? DBURLRequestBuilder(with: URL(string: mockObject.urlString))
                .set(method: HTTPMethod.get)
                .set(timeoutInterval: mockObject.testTimeout)
                .set(headers: mockObject.defaultHeaders)
                .build()
        else { fatalError("Building URLRequest failed") }
        
        URLProtocolMock.testURLs = [URL(string: mockObject.urlString): Data(mockObject.settingsJsonResponse.utf8)]
        URLProtocolMock.response = mockObject.validResponse
        
        let publisher: AnyPublisher<Settings, Error> = apiRequest.getData(for: urlRequest)
        
        let cancellable = publisher.sink (receiveCompletion: { (completion) in
            switch completion {
            case .failure(let error):
                print("--TEST ERROR--")
                print(error.localizedDescription)
                print("------")
                expectationFailure.fulfill()
            case .finished:
                expectationFinished.fulfill()
            }
        }, receiveValue: { value in
            XCTAssertNotNil(value)
            XCTAssertEqual(value.title, self.mockObject.settings.title)
            XCTAssertEqual(value.subtitle, self.mockObject.settings.subtitle)
            expectationReceive.fulfill()
        })
        
        wait(for: [expectationFinished,
                   expectationReceive,
                   expectationFailure],
             timeout: mockObject.testTimeout)
        cancellable.cancel()
    }

}

extension APIRequestSettingsTest {
    
    func evalValidResponseTest<T:Publisher>(publisher: T?)
    -> (expectations:[XCTestExpectation], cancellable: AnyCancellable?) {
        XCTAssertNotNil(publisher)
        
        let expectationFinished = expectation(description: "finished")
        let expectationReceive = expectation(description: "receiveValue")
        let expectationFailure = expectation(description: "failure")
        expectationFailure.isInverted = true
        
        let cancellable = publisher?.sink (receiveCompletion: { (completion) in
            switch completion {
            case .failure(let error):
                print("--TEST ERROR--")
                print(error.localizedDescription)
                print("------")
                expectationFailure.fulfill()
            case .finished:
                expectationFinished.fulfill()
            }
        }, receiveValue: { response in
            XCTAssertNotNil(response)
            print(response)
            expectationReceive.fulfill()
        })
        return (expectations: [expectationFinished,
                               expectationReceive,
                               expectationFailure],
                cancellable: cancellable
        )
    }
    
    func evalInvalidResponseTest<T:Publisher>(publisher: T?)
    -> (expectations:[XCTestExpectation], cancellable: AnyCancellable?) {
        
        XCTAssertNotNil(publisher)
        
        let expectationFinished = expectation(description: "Invalid.finished")
        expectationFinished.isInverted = true
        let expectationReceive = expectation(description: "Invalid.receiveValue")
        expectationReceive.isInverted = true
        let expectationFailure = expectation(description: "Invalid.failure")
        
        let cancellable = publisher?.sink (receiveCompletion: { (completion) in
            switch completion {
            case .failure(let error):
                print("--TEST FULFILLED--")
                print(error.localizedDescription)
                print("------")
                expectationFailure.fulfill()
            case .finished:
                expectationFinished.fulfill()
            }
        }, receiveValue: { response in
            XCTAssertNotNil(response)
            print(response)
            expectationReceive.fulfill()
        })
        return (expectations: [expectationFinished,
                               expectationReceive,
                               expectationFailure],
                cancellable: cancellable)
    }
}
