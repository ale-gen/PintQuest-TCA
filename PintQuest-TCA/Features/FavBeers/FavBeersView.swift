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
        enum Animation {
            static let response: CGFloat = 0.9
            static let dampingFraction: CGFloat = 0.9
            static let blendDuration: CGFloat = 0.1
        }
        enum EmptyState {
            static let yOffset: CGFloat = -50.0
            static let image: Image = Image("Beers")
        }
    }
    
    var store: StoreOf<FavBeers>
    let animation: Namespace.ID
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Group {
                ScrollView {
                    LazyVStack {
                        favBeersList(viewStore)
                    }
                    .padding(.horizontal, Constants.horizontalPadding)
                    .padding(.vertical, Constants.verticalPadding)
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
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
                                                    animation: animation,
                                                    showImage: .constant(false)),
                        label: {
                            BeerCell(beer: beerViewStore.state.beer,
                                     animation: animation,
                                     shouldHideImage: .constant(false))
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
        FavBeersView(store: Store(initialState: FavBeers.State(beers: IdentifiedArrayOf(uniqueElements: [BeerDetails.State(id: UUID(), beer: Beer.mock)])),
                               reducer: FavBeers()),
                  animation: animation)
    }
}
