//
//  FavBeersView.swift
//  PintQuest-TCA
//
//  Created by Aleksandra Generowicz on 12/05/2023.
//

import ComposableArchitecture
import SwiftUI

struct FavBeersView: View {
    
    private enum Constants {
        static let horizontalPadding: CGFloat = 15.0
        static let verticalPadding: CGFloat = 20.0
        enum EmptyState {
            static let yOffset: CGFloat = -50.0
            static let image: Image = Image("Beers")
        }
    }
    
    let animation: Namespace.ID
    var store: StoreOf<FavBeers>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            Group {
                ScrollView {
                    LazyVStack {
                        favBeersList(viewStore)
                    }
                    .padding(.horizontal, Constants.horizontalPadding)
                    .padding(.vertical, Constants.verticalPadding)
                }
            }
            .onAppear { viewStore.send(.onAppear) }
        }
    }
    
    @ViewBuilder
    private func favBeersList(_ viewStore: ViewStore<FavBeers.State, FavBeers.Action>) -> some View {
        ForEachStore(
            store.scope(state: \.beers,
                        action: FavBeers.Action.beer(id:action:)
                       ),
            content: { beerStore in
                WithViewStore(beerStore) { beerViewStore in
                    NavigationLink(
                        destination: BeerDetailView(store: beerStore,
                                                    animation: animation),
                        label: {
                            BeerCell(beer: beerViewStore.state.beer,
                                     animation: animation,
                                     shouldHideImage: beerViewStore.state.showImage)
                        }
                    )
                }
            }
        )
    }
}

struct FavBeersView_Previews: PreviewProvider {
    @Namespace static var animation
    
    static var previews: some View {
        FavBeersView(animation: animation,
                     store: Store(initialState: FavBeers.State(beers: IdentifiedArrayOf(uniqueElements: [BeerDetails.State(id: UUID(), beer: Beer.mock)])),
                                  reducer: FavBeers()))
    }
}
