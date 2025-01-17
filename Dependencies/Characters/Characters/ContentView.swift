//
//  ContentView.swift
//  Characters
//
//  Created by Sourabh Bhardwaj on 13/06/24.
//

import SwiftUI
import CharacterKit

struct ContentView: View {
    var body: some View {
        CharactersHome(config: CharactersConfigurationImpl())
    }
}

#Preview {
    CharactersHome(config: CharactersConfigurationImpl())
}
