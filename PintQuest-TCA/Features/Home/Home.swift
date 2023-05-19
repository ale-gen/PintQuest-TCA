//
//  HomeCore.swift
//  PintQuest-TCA
//
//  Created by Aleksandra Generowicz on 30/04/2023.
//

import ComposableArchitecture
import Foundation

struct Home: ReducerProtocol {
    enum State: Equatable, CaseIterable, Hashable {
        
        static var allCases: [State] {
            return [.browse(.init()), .fav(.init())]
        }
        
        var identifier: String {
            return UUID().uuidString
        }
        
        public func hash(into hasher: inout Hasher) {
            return hasher.combine(identifier)
        }
        
        public static func == (lhs: State, rhs: State) -> Bool {
            return lhs.identifier == rhs.identifier
        }
        
        case browse(Beers.State)
        case fav(FavBeers.State)
        
        public init() {
            self = .browse(Beers.State())
        }
        
        var name: String {
            switch self {
            case .browse:
                return Localizable.browseMenuTabTitle.value
            case .fav:
                return Localizable.favouriteMenuTabTitle.value
            }
        }
        
        var action: Action {
            switch self {
            case .browse:
                return .favBeers(.browseAllBeers)
            case .fav:
                return .browse(.favBeers)
            }
        }
    }
    
    enum Action {
        case browse(Beers.Action)
        case favBeers(FavBeers.Action)
    }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .browse(.favBeers):
                state = .fav(FavBeers.State())
                return .none
                
            case .browse:
                return .none
                
            case .favBeers(FavBeers.Action.browseAllBeers):
                state = .browse(Beers.State())
                return .none
                
            case .favBeers:
                return .none
            }
        }
        .ifCaseLet(/State.browse, action: /Action.browse) {
            Beers()
        }
        .ifCaseLet(/State.fav, action: /Action.favBeers) {
            FavBeers()
        }
    }
}
