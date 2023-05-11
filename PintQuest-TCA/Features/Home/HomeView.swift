//
//  HomeView.swift
//  PintQuest-TCA
//
//  Created by Aleksandra Generowicz on 30/04/2023.
//

import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    
    private enum Constants {
        static let spacing: CGFloat = 15.0
        static let yOffset: CGFloat = 2.0
        static let verticalPadding: CGFloat = 15.0
        static let horizontalPadding: CGFloat = 20.0
    }
    
    let store: StoreOf<Home>
    @Namespace var animation
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                VStack {
                    HStack(spacing: Constants.spacing) {
                        ForEach(Home.HomeTab.allCases, id: \.self) { tab in
                            Button {
//                                withAnimation {
                                    viewStore.send(.changeSelectedTab(tab))
//                                }
                                
                            } label: {
                                Text(tab.name)
                                    .foregroundColor(viewStore.selectedTab == tab ? .black : .gray)
                                    .font(viewStore.selectedTab == tab ? .title3 : .callout)
                                    .fontWeight(viewStore.selectedTab == tab ? .bold : .semibold)
                                    .padding(.leading, viewStore.selectedTab == tab ? .zero : Constants.spacing)
                                    .offset(y: viewStore.selectedTab == tab ? .zero : Constants.yOffset)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, Constants.verticalPadding)
                    .padding(.horizontal, Constants.horizontalPadding)
                    
                    switch viewStore.selectedTab {
                    case .browse:
                        BeersView(store: beersStore, animation: animation)
                            .tag(Home.HomeTab.browse)
                    case .fav:
                        EmptyView()
//                        FavBeersView(store: favouritesStore)
                    }
                }
                .overlay {
//                    if let selectedBeer, showDetailView {
//                        BeerDetailView(animation: animation,
//                                       beer: selectedBeer,
//                                       viewModel: memoryViewModel,
//                                       show: $showDetailView)
//                        .transition(.identity)
//                        .navigationTitle(String.empty)
//                        .toolbar(.hidden, for: .navigationBar)
//                    }
                }
//                .searchable(text: $searchName, prompt: Localizable.beerSearchBarPrompt.value)
                .navigationTitle(Localizable.homeNavigationBarTitle.value)
                .transition(.opacity)
//                .onChange(of: searchName) { newValue in
//                    apiViewModel.resetPagination()
//                    guard newValue.isEmpty else {
//                        memoryViewModel.getBeersByName(newValue)
//                        apiViewModel.getBeersByName(newValue)
//                        return
//                    }
//                    memoryViewModel.getBeers()
//                    apiViewModel.getBeers()
//                }
            }
        }
    }
}

//MARK: Store inits
extension HomeView {
    private var beersStore: StoreOf<Beers> {
        return store.scope(
            state: \.beersState,
            action: Home.Action.beers
        )
    }
    
    private var favouritesStore: StoreOf<FavBeers> {
        return store.scope(
            state: \.favBeersState,
            action: Home.Action.favBeers
        )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: .init(initialState: Home.State(),
                              reducer: Home()))
    }
}

