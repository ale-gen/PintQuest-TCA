//
//  BeersView.swift
//  PintQuest-TCA
//
//  Created by Aleksandra Generowicz on 30/04/2023.
//

import ComposableArchitecture
import SwiftUI

struct BeersView: View {
    
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
    
    var store: StoreOf<Beers>
    let animation: Namespace.ID
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Group {
                if viewStore.isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        LazyVStack {
                            beersList(viewStore)
                        }
                        .padding(.horizontal, Constants.horizontalPadding)
                        .padding(.vertical, Constants.verticalPadding)
                    }
                    if viewStore.isLoadingPage {
                        ProgressView()
                    }
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
    
    @ViewBuilder
    private func beersList(_ viewStore: ViewStore<Beers.State, Beers.Action>) -> some View {
        ForEachStore(
            store.scope(state: \.beers,
                        action: Beers.Action.beer(id:action:)
                       ),
            content: { beerStore in
                WithViewStore(beerStore) { beerViewStore in
                    //TODO: Remove navigation link
                    NavigationLink(
                        destination: BeerDetailView(store: beerStore,
                                                    animation: animation),
                        label: {
                            BeerCell(beer: beerViewStore.state.beer,
                                     animation: animation,
                                     shouldHideImage: false)
                            .onAppear {
                                viewStore.send(.retrieveNextPageIfNeeded(currentItemId: beerViewStore.state.beer.id))
                            }
                        }
                    )
                }
            }
        )
    }
}

struct BeersView_Previews: PreviewProvider {
    @Namespace static var animation
    
    static var previews: some View {
        BeersView(store: Store(initialState: Beers.State(beers: IdentifiedArrayOf(uniqueElements: [BeerDetails.State(id: UUID(), beer: Beer.mock)])),
                               reducer: Beers()),
                  animation: animation)
    }
}

