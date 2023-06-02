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
                        ForEach(Home.State.allCases, id: \.self) { tab in
                            Button {
                                viewStore.send(tab.action, animation: .easeInOut)
                            } label: {
                                Text(tab.name)
                                    .foregroundColor(viewStore.state.name == tab.name ? .black : .gray)
                                    .font(viewStore.state.name == tab.name ? .title3 : .callout)
                                    .fontWeight(viewStore.state.name == tab.name ? .bold : .semibold)
                                    .padding(.leading, viewStore.state.name == tab.name ? .zero : Constants.spacing)
                                    .offset(y: viewStore.state == tab ? .zero : Constants.yOffset)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, Constants.verticalPadding)
                    .padding(.horizontal, Constants.horizontalPadding)
                    
                    SwitchStore(store) {
                        CaseLet(state: /Home.State.browse, action: Home.Action.browse) { store in
                            BeersView(animation: animation, store: store)
                        }
                        CaseLet(state: /Home.State.fav, action: Home.Action.favBeers) { store in
                            FavBeersView(animation: animation, store: store)
                        }
                    }
                }
                .navigationTitle(Localizable.homeNavigationBarTitle.value)
                .navigationViewStyle(.stack)
                .transition(.opacity)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: .init(initialState: Home.State(),
                              reducer: Home()))
    }
}

