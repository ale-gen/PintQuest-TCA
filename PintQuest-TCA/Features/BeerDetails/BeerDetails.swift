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
      case favouritesResponse(TaskResult<[Beer]>)
      case toggleFavouriteResponse(TaskResult<[Beer]>)
    }
    
    @Dependency(\.favClient) var favClient
    
    private enum BeerDetailCancelId {}
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .onAppear:
            state.showImage = true
            return .run { send in
                await send(.favouritesResponse(TaskResult { try await self.favClient.all() }))
            }
            
        case .toggleFavourite:
            if state.isFavourite {
                return .run { [id = state.beer.id] send in
                    await send(.toggleFavouriteResponse(TaskResult { try await self.favClient.remove(id) }))
                }
            } else {
                return .run { [id = state.beer.id] send in
                    await send(.toggleFavouriteResponse(TaskResult { try await self.favClient.add(id) }))
                }
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
            
        case .favouritesResponse(.failure(_)), .toggleFavouriteResponse(.failure(_)):
            return .none
        }
    }
}
