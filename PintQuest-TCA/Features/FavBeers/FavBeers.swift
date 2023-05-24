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
        var isLoading: Bool = false
    }
    
    enum Action {
        case onAppear
        case loadingActive(Bool)
        case retrieveFavourites
        case favouritesResponse(TaskResult<[Beer]>)
        case beer(id: UUID, action: BeerDetails.Action)
        case browseAllBeers
    }
    
    @Dependency(\.favClient) var favClient
    
    private enum FavBeersCancelId {}
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .retrieveFavourites:
                state.beers = []
                return .run { send in
                    await send(.loadingActive(true))
                    await send(.favouritesResponse(TaskResult { try await self.favClient.all() }))
                }
                
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
                
            case .favouritesResponse(.failure(_)):
                return .send(.loadingActive(false))
                
            case .beer(id: _, action: .onDisappear):
                return .init(value: .retrieveFavourites)
                
            case .beer(id: _, action: _):
                return .none
                
            case .browseAllBeers:
                return .none
                
            case .onAppear:
                guard state.beers.isEmpty else { return .none }
                return .init(value: .retrieveFavourites)
                
            case .loadingActive(let isLoading):
                state.isLoading = isLoading
                return .none
            }
        }
        .forEach(\.beers, action: /Action.beer(id:action:)) {
            BeerDetails()
        }
    }
}
