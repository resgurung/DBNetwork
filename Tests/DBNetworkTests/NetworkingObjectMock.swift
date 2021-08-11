//
//  MockObject.swift
//  Tests iOS
//
//  Created by Robin Gurung on 09/08/2021.
//

import XCTest
import Foundation

@testable import DBNetwork
struct Settings: Identifiable, Codable {

    var id:                 UUID?
    
    var title:              String

    var subtitle:           String
}

class NetworkingObjectMock {
    
    let settings = Settings(
        title: "title",
        subtitle: "subtitle"
    )
    
    let settingsJsonResponse = """
        {
                                "title": "title",
                                "subtitle": "subtitle"

                    
        }
        """
    
    let testTimeout: TimeInterval = 1
    
    let urlString = "http://infinite.co.uk/wp-json/db/v1/settings"
    
    let defaultHeaders = [HTTPHeader.accept,
                          HTTPHeader.contentType,
                          HTTPHeader.cacheControl]
    
    let validResponse = HTTPURLResponse(
        url: URL(string: "http://infinite.co.uk/wp-json/db/v1/settings")!,
        statusCode: 200,
        httpVersion: nil,
        headerFields: [
            "Content-Type": "application/json",
            "cache-control": "no-cache",
        ]
    )
    
    let invalidResponse = URLResponse(
        url: URL(string: "http://infinite.co.uk/wp-json/db/v1/settings")!,
        mimeType: nil,
        expectedContentLength: 0,
        textEncodingName: nil)
    
    let invalidResponse300 = HTTPURLResponse(
        url: URL(string: "http://infinite.co.uk/wp-json/db/v1/setting")!,
        statusCode: 300,
        httpVersion: nil,
        headerFields: nil)
    
    let invalidResponse401 = HTTPURLResponse(
        url: URL(string: "http://infinite.co.uk/wp-json/db/v1/settings")!,
        statusCode: 401,
        httpVersion: nil,
        headerFields: nil)
    
    let networkError = NSError(
        domain: "NSURLErrorDomain",
        code: -1004, //kCFURLErrorCannotConnectToHost
        userInfo: nil
    )
    
}
