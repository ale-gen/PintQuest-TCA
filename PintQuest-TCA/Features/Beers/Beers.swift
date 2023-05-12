//
//  Beers.swift
//  PintQuest-TCA
//
//  Created by Aleksandra Generowicz on 30/04/2023.
//

import ComposableArchitecture
import Foundation

struct Beers: ReducerProtocol {
    struct State: Equatable {
        var beers = IdentifiedArrayOf<BeerDetails.State>()
        var favourites: [Beer] = []
        
        var currentPage: Int = 1
        var isLoading: Bool = false
        var isLoadingPage: Bool = false
        
        func isFavorite(_ beer: Beer) -> Bool {
            return favourites.contains(where: { $0.id == beer.id })
        }
        
        func isLastItem(_ itemId: Int) -> Bool {
            let itemIndex = beers.firstIndex(where: { $0.beer.id == itemId })
            return itemIndex == beers.endIndex - 1
        }
    }
    
    enum Action {
        case retrieve
        case retrieveNextPageIfNeeded(currentItemId: Int)
        case beersResponse(TaskResult<[Beer]>)
        
        case retrieveFavorites
        case favoritesResponse(TaskResult<[Beer]>)
        
        case loadingActive(Bool)
        case loadingPageActive(Bool)
        
        case beer(id: UUID, action: BeerDetails.Action)
        
        case onAppear
    }
    
    @Dependency(\.punkAPIClient) var punkAPIClient
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard state.beers.isEmpty else { return .init(value: .retrieveFavorites) }
                return .init(value: .retrieve)
                
            case .retrieve:
                state.beers = []
                state.currentPage = 1
                return .run { [page = state.currentPage] send in
                    await send(.loadingActive(true))
                    await send(.beersResponse(TaskResult { try await self.punkAPIClient.fetchByPage(page) }))
                }
                
            case .retrieveNextPageIfNeeded(currentItemId: let itemId):
                guard state.isLastItem(itemId) else { return .none }
                state.currentPage += 1
                return .run { [page = state.currentPage] send in
                    await send(.loadingPageActive(true))
                    await send(.beersResponse(TaskResult { try await self.punkAPIClient.fetchByPage(page) }))
                }
                
            case .retrieveFavorites:
                // TODO: Fetch fav beers from fav client
                return .none
                
            case .beer(id:action:):
                return .none
                
            case .beersResponse(.success(let beers)):
                beers.forEach { beer in
                    state.beers.append(
                        BeerDetails.State(id: UUID(),
                                          beer: beer)
                    )
                }
                return .run { send in
                    await send(.loadingActive(false))
                    await send(.loadingPageActive(false))
                }
                
            case .favoritesResponse(.failure(_)):
                return .none
                
            case .beersResponse(.failure(_)):
                return .concatenate(
                    .init(value: .loadingActive(false)),
                    .init(value: .loadingPageActive(false))
                )
                
            case .favoritesResponse(.success(let favBeers)):
                state.favourites = favBeers
                return .none
                
            case .loadingActive(let isLoading):
                state.isLoading = isLoading
                return .none
                
            case .loadingPageActive(let isLoadingPage):
                state.isLoadingPage = isLoadingPage
                return .none
            }
        }
        
        .forEach(\.beers, action: /Action.beer(id:action:)) {
            BeerDetails()
        }
    }
}
