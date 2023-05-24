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
        
        var currentPage: Int = 1
        var isLoading: Bool = false
        var isLoadingPage: Bool = false
        
        func isLastItem(_ itemId: Int) -> Bool {
            let itemIndex = beers.firstIndex(where: { $0.beer.id == itemId })
            return itemIndex == beers.endIndex - 1
        }
    }
    
    enum Action {
        case onAppear
        case loadingActive(Bool)
        case loadingPageActive(Bool)
        case retrieve
        case retrieveNextPageIfNeeded(currentItemId: Int)
        case favBeers
        case beersResponse(TaskResult<[Beer]>)
        case beer(id: UUID, action: BeerDetails.Action)
    }
    
    @Dependency(\.punkAPIClient) var punkAPIClient
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard state.beers.isEmpty else { return .none }
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
                
            case .beer(id:action:):
                return .none
                
            case .favBeers:
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
            
            case .beersResponse(.failure(_)):
                return .concatenate(
                    .init(value: .loadingActive(false)),
                    .init(value: .loadingPageActive(false))
                )
                
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
