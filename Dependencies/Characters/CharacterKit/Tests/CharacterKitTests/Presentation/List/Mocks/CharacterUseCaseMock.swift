//
//  CharacterUseCaseMock.swift
//
//
//  Created by Sourabh Bhardwaj on 19/06/24.
//

import Foundation
import Combine
import CoreKit

@testable import CharacterKit

enum MockError: Error {
    case typeMismatch
}

class CharacterUseCaseMock: CharacterUseCase {
    var expectedResult: Result<AnyPublisher<CharactersImpl, Error>, Error>?
    
    func characters<T>(params: CharacterParameters) async throws -> AnyPublisher<T, Error> where T : Decodable {
        if let expectedResult = expectedResult {
            switch expectedResult {
            case .success(let publisher):
                guard let typedPublisher = publisher as? AnyPublisher<T, Error> else {
                    throw MockError.typeMismatch
                }
                return typedPublisher
            case .failure(let error):
                return Fail(error: error).eraseToAnyPublisher()
            }
        } 
        else {
            throw URLError(.badServerResponse)
        }
    }
    
    func incrementPage(currentPage: Int) -> Int {
        return currentPage + 1
    }
    
}
