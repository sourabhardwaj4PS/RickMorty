//
//  MockURLProtocol.swift
//
//
//  Created by Sourabh Bhardwaj on 14/06/24.
//

import Combine
import Foundation

public class MockURLProtocol: URLProtocol {
    
    // MARK: - Mocking Data
    public static var error: Error?
    public static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    public static var requestFailed = false
    public static var decodingFailed = false
        
    public static func resetMockData() {
        error = nil
        requestHandler = nil
        requestFailed = false
        decodingFailed = false
    }
    
    /// Avoid fatalError("Handler is unavailable.")
    public static func populateRequestHandler() {
        requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 0, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }
    }

    // MARK: - Class Methods

    public override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    public override func startLoading() {
        do {
            guard let handler = MockURLProtocol.requestHandler else {
                fatalError("Handler is unavailable.")
            }

//            if MockURLProtocol.decodingFailed {
//                throw ApiError.decodingFailed
//            }
            
            let (response, data) = try handler(request)
            
            if MockURLProtocol.requestFailed {
                client?.urlProtocol(self, didReceive: URLResponse(), cacheStoragePolicy: .notAllowed)
            } 
            else {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }

            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } 
        catch {
            //let unknownError = ApiError.unknownError(error)
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    public override func stopLoading() {
        // implement if needed
    }
}

