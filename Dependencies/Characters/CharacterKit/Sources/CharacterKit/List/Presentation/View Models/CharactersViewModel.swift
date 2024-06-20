//
//  CharactersViewModel.swift
//  
//
//  Created by Sourabh Bhardwaj on 19/06/24.
//

import Foundation
import CoreKit

/**
 A protocol for objects that handle the publishable character details.
 */
public protocol PublishableCharacters: ObservableObject {
    var characters: [CharacterViewModel] { get set }
    
    // error handling
    var isServerError: Bool { get set }
    var errorMessage: String? { get set }
}

/**
 A protocol for objects that handle network operations related to a character.
 */
public protocol NetworkableCharacters {
    func loadCharacters() async
    
    // pagination
    var currentPage: Int { get set }
}

/**
 A protocol that combines functionality related to character details.
 */
public protocol CharactersViewModel: PublishableCharacters, NetworkableCharacters {
    var isLoading: Bool { get set }
    var hasAppeared: Bool { get set }
}
