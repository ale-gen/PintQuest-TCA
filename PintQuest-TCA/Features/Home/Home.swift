//
//  HomeCore.swift
//  PintQuest-TCA
//
//  Created by Aleksandra Generowicz on 30/04/2023.
//

import ComposableArchitecture
import Foundation

struct Home: ReducerProtocol {
    
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
    
    struct State: Equatable {
        var search: String = .empty
        var selectedTab: HomeTab = .browse
        var beersState = Beers.State()
        var favBeersState = FavBeers.State()
    }
    
    enum Action {
        case beers(Beers.Action)
        case favBeers(FavBeers.Action)
        case changeSelectedTab(HomeTab)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .beers(.beer(id: _, action: .toggleFavouriteResponse(.success(let favBeers)))):
                state.favBeersState.beers = .init(uniqueElements: favBeers.map { beer in
                    BeerDetails.State(id: UUID(),
                                      beer: beer)
                })
                return .none
            case .changeSelectedTab(let tab):
                state.selectedTab = tab
                return .none
            default:
                return .none
            }
        }
        
        Scope(state: \.beersState, action: /Action.beers) {
            Beers()
        }

    }
}
