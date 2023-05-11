//
//  FavBeers.swift
//  PintQuest-TCA
//
//  Created by Aleksandra Generowicz on 30/04/2023.
//

import ComposableArchitecture
import Foundation

struct FavBeers: ReducerProtocol {
    struct State: Equatable {
        var beers = IdentifiedArrayOf<BeerDetails.State>()
    }
    
    enum Action {
        case retrieveFavourites
        case favouritesResponse(Result<[Beer], Never>)
        case beer(id: UUID, action: BeerDetails.Action)
        case onAppear
        case onDisappear
    }
    
    private enum FavBeersCancelId {}
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .retrieveFavourites:
            // MARK: Fetch all fav beers
            return .none
        case .favouritesResponse(.success(let favBeers)):
            state.beers = .init(
                uniqueElements: favBeers.map {
                    BeerDetails.State(
                        id: UUID(),
                        beer: $0
                    )
                }
            )
            return .none
        case .beer(id: _, action: .onDisappear):
            return .init(value: .retrieveFavourites)
        case .beer(id: _, action: _):
            return .none
        case .onAppear:
            guard state.beers.isEmpty else { return .none }
            return .init(value: .retrieveFavourites)
        case .onDisappear:
            return .cancel(id: FavBeersCancelId.self)
        }
    }
}
