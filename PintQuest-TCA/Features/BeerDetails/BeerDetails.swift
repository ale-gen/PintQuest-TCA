//
//  BeerDetails.swift
//  PintQuest-TCA
//
//  Created by Aleksandra Generowicz on 30/04/2023.
//

import ComposableArchitecture
import Foundation

struct BeerDetails: ReducerProtocol {
    struct State: Equatable, Identifiable {
        let id: UUID
        var beer: Beer
        
        var isFavourite: Bool = false
        var favourites: [Beer] = []
        
        // MARK: For animations
        var showImage: Bool = false
    }
    
    enum Action {
      case onAppear
      case onDisappear

      case toggleFavourite
      case favouritesResponse(Result<[Beer], Never>)
      case toggleFavouriteResponse(Result<[Beer], Never>)
    }
    
    private enum BeerDetailCancelId {}
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .onAppear:
            state.showImage = true
            // MARK: Fetch fav beers
            return .none
        case .toggleFavourite:
            if state.isFavourite {
                // MARK: Remove from fav
                state.isFavourite.toggle()
                return .none
            } else {
                // MARK: Add to fav
                state.isFavourite.toggle()
                return .none
            }
        case .favouritesResponse(.success(let favourites)),
                .toggleFavouriteResponse(.success(let favourites)):
            state.favourites = favourites
            state.isFavourite = favourites.contains(where: { $0.id == state.beer.id })
            return .none
        case .onDisappear:
            state.showImage = false
            // MARK: Cancel queue
            return .cancel(id: BeerDetailCancelId.self)
        }
    }
}
