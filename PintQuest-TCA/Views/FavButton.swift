//
//  FavButton.swift
//  PintQuest-TCA
//
//  Created by Aleksandra Generowicz on 29/04/2023.
//

import ComposableArchitecture
import SwiftUI

struct FavButton: ReducerProtocol {
    struct State: Equatable {
        var isMarked: Bool = false
    }
    
    enum Action {
        case toogle
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .toogle:
            state.isMarked.toggle()
            return .none
        }
    }
}

struct FavButtonView: View {
    
    private enum Constants {
        static let font: Font = .title2
        static let fontWeight: Font.Weight = .semibold
        static let color: Color = .black
        static let horizontalPadding: CGFloat = 25.0
    }
    
    var store: StoreOf<FavButton>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Button(action: {
                viewStore.send(.toogle)
            }) {
                Image(systemName: viewStore.isMarked ? Icons.heartFill.name : Icons.heart.name)
            }
            .font(Constants.font)
            .fontWeight(Constants.fontWeight)
            .foregroundColor(Constants.color)
            .padding(Constants.horizontalPadding)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
    }
}

struct FavButton_Previews: PreviewProvider {
    static var previews: some View {
        FavButtonView(store: Store(initialState: FavButton.State(),
                                   reducer: FavButton()))
    }
}
