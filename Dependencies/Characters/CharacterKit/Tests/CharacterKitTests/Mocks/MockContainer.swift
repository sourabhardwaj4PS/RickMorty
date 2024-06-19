//
//  MockContainer.swift
//
//
//  Created by Sourabh Bhardwaj on 16/06/24.
//

import Foundation
import CoreKit
import NetworkKit

@testable import CharacterKit

public class MockContainer {
    
    /**
     Sets up "Mock" Dependencies for abstractions with respective implementations.
     */
    public static func setupMockDependencies() {
        ///
        /// Character dependencies
        ///
        DependencyContainer.register(type: (any CharactersViewModel).self, CharactersViewModelImpl())
        
        DependencyContainer.register(type: (any CharacterUseCase).self, CharacterUseCaseImpl())
        
        DependencyContainer.register(type: (any CharacterRepository).self, CharacterRepositoryImpl())
        
        DependencyContainer.register(type: (any CharacterDataSource).self, CharacterRemoteDataSourceImpl())
        
        ///
        /// Character details dependencies
        ///
        DependencyContainer.register(type: (any CharacterDetailsUseCase).self, CharacterDetailsUseCaseImpl())
        
        DependencyContainer.register(type: (any CharacterDetailsRepository).self, CharacterDetailsRepositoryImpl())
        
        DependencyContainer.register(type: (any CharacterDetailsDataSource).self, CharacterDetailsRemoteDataSourceImpl())
        
        ///
        /// Api Client dependency
        ///
        DependencyContainer.register(type: (SessionApiClient<CharactersEndpoint>).self, SessionApiClient<CharactersEndpoint>(session: MockURLSession()))
    }
}
