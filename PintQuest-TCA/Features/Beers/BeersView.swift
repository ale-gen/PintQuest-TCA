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
                //            if viewModel.loaded && viewModel.beers.isEmpty {
                //                EmptyStateView(model: EmptyState(image: Constants.EmptyState.image, title: Localizable.emptyStateTitleBrowseBeersCollection.value, buttonTitle: Localizable.emptyStateButtonTitleBrowseBeersCollection.value))
                //                    .offset(y: Constants.EmptyState.yOffset)
                //            } else {
                ScrollView {
                    LazyVStack {
                        //                        beersList(viewStore)
                        ForEach(viewStore.beers) { beerDetails in
                            BeerCell(beer: beerDetails.beer,
                                     animation: animation,
                                     shouldHideImage: false)
                            .onAppear {
                                viewStore.send(.retrieveNextPageIfNeeded(currentItemId: beerDetails.beer.id))
                            }
                            //                            .onTapGesture {
                            //                            //                                withAnimation(.interactiveSpring(response: Constants.Animation.response, dampingFraction: Constants.Animation.dampingFraction, blendDuration: Constants.Animation.blendDuration)) {
                            //                            //                                    selectedBeer = beer
                            //                            //                                    showDetailView = true
                            //                            //                                }
                            //                            //                            }
                        }
                    }
                    .padding(.horizontal, Constants.horizontalPadding)
                    .padding(.vertical, Constants.verticalPadding)
                }
                //            }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .onDisappear {
                viewStore.send(.onDisappear)
            }
        }
    }
    
    //    @ViewBuilder
    //    private func beersList(_ viewStore: ViewStore<Beers.State, Beers.Action>) -> some View {
    //        ForEachStore(
    //            store.scope(state: { $0.beers },
    //                        action: Beers.Action.beer(id:action:)
    //                       ),
    //            content: { beerStore in
    //                WithViewStore(beerStore) { beerViewStore in
    //                    NavigationLink(
    //                        destination: BeerDetailView(store: beerStore),
    //                        label: {
    //                            BeerCell(beer: beerViewStore.state.beer,
    //                                     animation: animation,
    //                                     shouldHideImage: false)
    //                            .onAppear {
    //                                viewStore.send(.retrieveNextPageIfNeeded(currentItemId: beerViewStore.state.beer.id))
    //                            }
    //                        }
    //                    )
    //                }
    //            }
    //        )
    //    }
}

struct BeersView_Previews: PreviewProvider {
    @Namespace static var animation
    
    static var previews: some View {
        BeersView(store: Store(initialState: Beers.State(beers: IdentifiedArrayOf(uniqueElements: [BeerDetails.State(id: UUID(), beer: Beer.mock)])),
                               reducer: Beers()),
                  animation: animation)
    }
}

