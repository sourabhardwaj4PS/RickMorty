//
//  CharacterRowView.swift
//
//
//  Created by Sourabh Bhardwaj on 15/06/24.
//

import Foundation
import SwiftUI
import CoreKit

struct CharacterRowView<T>: View where T: CharacterViewModel {
    
    @State var viewModel: T
    
    public init(viewModel: @autoclosure @escaping () -> T) {
        _viewModel = State(wrappedValue: viewModel())
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ImageView(imageUrlString: viewModel.image)
                .frame(width: 134, height: 134)
                .cornerRadius(5)
                .accessibilityIdentifier("thumbnailView-\(viewModel.id)")
            
            AttributesView(viewModel: viewModel)
            
            Spacer()
        }
        .background(Color.white)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("rowView-\(viewModel.id)")
    }
}

#Preview {
    CharacterRowView(viewModel: CharacterViewModelImpl(
        character: CharacterImpl(
            id: 1,
            name: "Citadel of Ricks",
            status: "Alive",
            species: "Cartoon",
            type: "",
            gender: "Males",
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            url: "none",
            created: "NA",
            episode: []
        ))
    )
}