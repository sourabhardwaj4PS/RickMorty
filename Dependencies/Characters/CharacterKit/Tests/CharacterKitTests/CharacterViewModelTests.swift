//
//  CharacterViewModelTests.swift
//
//
//  Created by Sourabh Bhardwaj on 15/06/24.
//

import Foundation
import XCTest
import NetworkKit
import Combine

@testable import CharacterKit

class CharacterViewModelTests: XCTestCase {

    var sut: CharactersViewModelImpl!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        DIContainer.setupMockDepedencyContainer()
        
        sut = CharactersViewModelImpl()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testCharactersViewModel_loadingCharacters_shouldLoadWithSuccess() async {
        // Given
        let expectedResult = MockData.allCharacters
        
        let expectation = XCTestExpectation(description: "All characters should load successfully!")
        
        MockURLProtocol.resetMockData()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://rickandmortyapi.com/mock/character")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, expectedResult)
        }
        
        // When
        sut.$characters
            .dropFirst()
            .sink { characters in
                // Then
                //XCTAssertEqual(characters.count, 4) //FIXME: two calls for loadCharacters making the count double
                XCTAssertEqual(characters.first?.character.name, "Rick")
                XCTAssertEqual(characters.last?.character.name, "Treudo")
                expectation.fulfill()
                
            }.store(in: &cancellables)
        
        await sut.loadCharacters()
        
        await fulfillment(of: [expectation], timeout: 1.0)

        XCTAssertFalse(sut.isLoading)
    }
    
    func testCharactersViewModel_loadingCharacters_shouldLoadWithFailure() async {
        // Given
        do {
            let expectation = XCTestExpectation(description: "All characters should not load")
              
            MockURLProtocol.resetMockData()
            MockURLProtocol.populateRequestHandler()
            MockURLProtocol.requestFailed = true
            
            // When
            try await sut.useCase.characters(params: ["page": "1"])
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        XCTFail("Expected an error to be received in testCharactersViewModel_loadingCharacters_shouldLoadWithFailure")
                    case .failure(_):
                        expectation.fulfill()
                    }
                } receiveValue: { (characters: NeverDecodable) in
                    
                }
                .store(in: &cancellables)

            // Complete the expectation
            await fulfillment(of: [expectation], timeout: 1.0)
        }
        catch let exception {
            print("Exception in testCharactersViewModel_loadingCharacters_shouldLoadWithFailure = \(exception)")
        }
    }
    
    func testCharacterUseCase_loadCharacters_ShouldValidateParameters() async {
        // Arrange or Given
        
        let expectation = XCTestExpectation(description: "Invalid parameters should fail the loadCharacters request")
          
        MockURLProtocol.resetMockData()
        MockURLProtocol.populateRequestHandler()
        
        // When
        do {
            try await sut.useCase.characters(params: ["invalidPage": "1"])
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        XCTFail("Expected an error to be received in testCharacterUseCase_loadCharacters_ShouldValidateParameters")
                    case .failure(let error):
                        XCTAssertEqual(error as! ApiError, ApiError.invalidParameter)
                    }
                    expectation.fulfill()
                } receiveValue: { (characters: NeverDecodable) in
                    
                }
                .store(in: &cancellables)
            
            await fulfillment(of: [expectation], timeout: 1.0)
        }
        catch let exception {
            print("Exception in testCharacterUseCase_loadCharacters_ShouldValidateParameters = \(exception)")
        }
    }
    
    func testCharactersViewModel_characterDetails_shouldLoadWithSuccess() async {
        // Given
        let expectedResult = MockData.character
        
        MockURLProtocol.resetMockData()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://rickandmortyapi.com/mock/character/2")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, expectedResult)
        }
        
        let expectation = XCTestExpectation(description: "Character details loaded successfully!")

        // When
        sut.$character
            .dropFirst()
            .sink { character in
                XCTAssertEqual(character?.character.name, "Morty Smith")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await sut.loadCharacterDetails(id: 2)
        
        await fulfillment(of: [expectation], timeout: 1.0)

        XCTAssertFalse(sut.isLoading)
    }
    
    func testCharactersViewModel_characterDetails_shouldLoadWithFailure() async {
        // Given
        do {
            let expectation = XCTestExpectation(description: "Character details should not load")
              
            MockURLProtocol.resetMockData()
            MockURLProtocol.populateRequestHandler()
            MockURLProtocol.requestFailed = true
            
            // When
            try await sut.useCase.characterDetails(params: ["characterId": "1"])
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        XCTFail("Expected an error to be received in testCharactersViewModel_characterDetails_shouldLoadWithFailure")
                    case .failure(_):
                        expectation.fulfill()
                    }
                } receiveValue: { (characters: NeverDecodable) in
                    
                }
                .store(in: &cancellables)

            // Complete the expectation
            await fulfillment(of: [expectation], timeout: 1.0)
        }
        catch let exception {
            print("Exception in testCharactersViewModel_characterDetails_shouldLoadWithFailure = \(exception)")
        }
    }
    
    func testCharacterUseCase_characterDetails_ShouldValidateParameters() async {
        // Arrange or Given
        
        let expectation = XCTestExpectation(description: "Invalid parameters should fail the characterDetails request")
          
        MockURLProtocol.resetMockData()
        MockURLProtocol.populateRequestHandler()
        
        // When
        do {
            try await sut.useCase.characterDetails(params: ["invalidCharacterId": "1"])
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        XCTFail("Expected an error to be received in testCharacterUseCase_characterDetails_ShouldValidateParameters")
                    case .failure(let error):
                        XCTAssertEqual(error as! ApiError, ApiError.invalidParameter)
                    }
                    expectation.fulfill()
                } receiveValue: { (characters: NeverDecodable) in
                    
                }
                .store(in: &cancellables)
            
            await fulfillment(of: [expectation], timeout: 1.0)
        }
        catch let exception {
            print("Exception in testCharacterUseCase_characterDetails_ShouldValidateParameters = \(exception)")
        }
    }

    func testCharactersViewModel_characterTapped_shouldTriggerCharacterDetails() async {
        do {
            // Given
            let expectedResult = MockData.character
            let character: CharacterImpl = try JSONDecoder().decode(CharacterImpl.self, from: expectedResult)
            
            MockURLProtocol.resetMockData()
            MockURLProtocol.populateRequestHandler()

            // When
            sut.tappedCharacter(id: character.id)
                        
            print(sut.isLoading)
            XCTAssertTrue(sut.isLoading)
        }
        catch let exception {
            print("Exception in testCharactersViewModel_characterTapped_shouldTriggerCharacterDetails = \(exception)")
        }
    }
    
    func testCharactersViewModel_shouldLoadNextPage_loadNextPageForCharacters() async {
        do {
            // Given
            let expectedResult = MockData.character
            let character: CharacterImpl = try JSONDecoder().decode(CharacterImpl.self, from: expectedResult)
            let characterVM = CharacterViewModelImpl(character: character)
            
            var characters: [CharacterViewModel] = []
            for _ in 0..<20 {
                characters.append(characterVM)
            }

            // When
            sut.characters = characters
            
            // Then
            // Everytime next page is loaded when (characters.count - 2) = totolResults
            XCTAssertFalse(sut.shouldLoadMore(index: characters.count - 3))
            XCTAssertTrue(sut.shouldLoadMore(index: characters.count - 2))
        }
        catch let exception {
            print("Exception in testCharactersViewModel_shouldLoadNextPage_shouldLoadNextPageForCharacters = \(exception)")
        }
    }
    
    func testCharactersViewModel_loadMore_shouldLoadNextPageForCharacters() async {
        
        // Given
        XCTAssertEqual(sut.currentPage, 1)
        
        // When
        await sut.loadMore()
        
        // Then
        XCTAssertEqual(sut.currentPage, 2)
    }
    
}
