//
//  CharacterDetailsUseCase.swift
//
//
//  Created by Sourabh Bhardwaj on 19/06/24.
//

import Foundation
import Combine
import CoreKit

public protocol CharacterDetailsUseCase {
    func characterDetails<T: Decodable>(params filter: Parameters) async throws -> AnyPublisher<T, Error>
}

public class CharacterDetailsUseCaseImpl: CharacterDetailsUseCase {
    @Dependency public var repository: CharacterDetailsRepository
    
    public init() { }
    
    public func characterDetails<T: Decodable>(params filter: Parameters) async throws -> AnyPublisher<T, Error> {
        return try await repository.characterDetails(params: filter)
    }
}