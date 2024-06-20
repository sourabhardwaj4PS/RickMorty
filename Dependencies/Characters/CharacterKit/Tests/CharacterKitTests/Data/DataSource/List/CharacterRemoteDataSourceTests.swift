//
//  CharacterRemoteDataSourceTests.swift
//
//
//  Created by Sourabh Bhardwaj on 20/06/24.
//

import Foundation
import XCTest
import Combine
import NetworkKit

@testable import CharacterKit

class CharacterRemoteDataSourceTests: XCTestCase {
    
    private var sut: CharacterRemoteDataSourceImpl!
    private var cancellables = Set<AnyCancellable>()
        
    override func setUpWithError() throws {
        MockContainer.setupMockDependencies()
        
        sut = CharacterRemoteDataSourceImpl()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testCharacterRemoteDataSource_loadingCharacters_shouldLoadWithSuccess() async {
        let expectation = XCTestExpectation(description: "Character Remote Data Source should load characters")
        
        // Given
        let expectedResult = MockData.allCharacters
        
        MockURLProtocol.resetMockData()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://example.com/mock/character")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, expectedResult)
        }
        
        let params = CharacterParameters(page: 1)

        do {
            // When
            let publisher: AnyPublisher<CharactersImpl, Error> = try await sut.characters(params: params)
            publisher
                .sink { completion in
                    if case .failure(_) = completion {
                        XCTFail("Not expected to receive failure")
                    }
                } receiveValue: { characters in
                    // Then
                    XCTAssertNotNil(characters)
                    expectation.fulfill()
                }
                .store(in: &cancellables)
            
            await fulfillment(of: [expectation], timeout: 1.0)
        }
        catch {
            print("Exception in testCharacterRemoteDataSource_loadingCharacters_shouldLoadWithSuccess = \(error)")
        }
    }
    
//    func testCharacterRemoteDataSource_loadingCharacters_shouldValidateRequiredParams() async {
//        let expectation = XCTestExpectation(description: "Characters Remote Data Source should load characters")
//        
//        // Given
//        let expectedError = ApiError.invalidParameter
//        
//        do {
//            // When
//            let publisher: AnyPublisher<CharacterImpl, Error> = try await sut.characters(params: ["invalidKey":"1"])
//            publisher
//                .dropFirst()
//                .sink { completion in
//                    if case .failure(let error) = completion {
//                        // Then
//                        XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
//                        expectation.fulfill()
//                    }
//                } receiveValue: { character in
//                    XCTFail("Not expected to receive success")
//                }
//                .store(in: &cancellables)
//            
//            await fulfillment(of: [expectation], timeout: 1.0)
//        }
//        catch {
//            DLog("Exception in testCharacterRemoteDataSource_loadingCharacters_shouldValidateRequiredParams = \(error)")
//        }
//    }
    
}
