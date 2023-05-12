//
//  HomeCore.swift
//  PintQuest-TCA
//
//  Created by Aleksandra Generowicz on 30/04/2023.
//

import ComposableArchitecture
import Foundation

struct Home: ReducerProtocol {
    
    struct State: Equatable {
        
        enum HomeTab: CaseIterable {
            case browse
            case fav
            
            var name: String {
                switch self {
                case .browse:
                    return Localizable.browseMenuTabTitle.value
                case .fav:
                    return Localizable.favouriteMenuTabTitle.value
                }
            }
        }
        
        var search: String = .empty
        var selectedTab: HomeTab = .browse
        var beersState = Beers.State()
        var favBeersState = FavBeers.State()
    }
    
    enum Action {
        case beers(Beers.Action)
        case favBeers(FavBeers.Action)
        case changeSelectedTab(State.HomeTab)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.beersState, action: /Action.beers) {
            Beers()
        }
        
        Reduce { state, action in
            switch action {
            case .changeSelectedTab(let tab):
                state.selectedTab = tab
                return .none
                
            case .beers(.beer(id: _, action: .toggleFavouriteResponse(.success(let favBeers)))):
                state.favBeersState.beers = .init(uniqueElements: favBeers.map { beer in
                    BeerDetails.State(id: UUID(),
                                      beer: beer)
                })
                return .none
                
            case .beers:
                return .none
                
            case .favBeers:
                // TODO: Fetch
                return .none
            }
        }
    }
}
