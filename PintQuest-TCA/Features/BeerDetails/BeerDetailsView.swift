//
//  BeerDetailsView.swift
//  PintQuest-TCA
//
//  Created by Aleksandra Generowicz on 29/04/2023.
//

import CachedAsyncImage
import ComposableArchitecture
import SwiftUI

struct BeerDetailView: View {
    
    private enum Constants {
        enum NavBar {
            static let font: Font = .title3
            static let fontWeight: Font.Weight = .semibold
            static let color: Color = .black
            static let horizontalPadding: CGFloat = 25.0
        }
        enum Tagline {
            static let font: Font = .subheadline
            static let fontWeight: Font.Weight = .semibold
            static let opacity: CGFloat = 0.8
        }
        enum Title {
            static let font: Font = .title
            static let fontWeight: Font.Weight = .semibold
        }
        enum ContentText {
            static let color: Color = .black.opacity(0.8)
        }
        enum Circle {
            static let color: Color = .beige
            static let additionalXOffset: CGFloat = -10.0
        }
        enum Image {
            static let padding: CGFloat = 80.0
            static let shadowRadius: CGFloat = 30.0
            static let xOffset: CGFloat = -UIScreen.main.bounds.midX + 20.0
        }
        enum Animation {
            static let duration: CGFloat = 0.35
            static let response: CGFloat = 0.9
            static let dampingFraction: CGFloat = 0.9
            static let blendDuration: CGFloat = 0.1
        }
        enum Background {
            static let color: Color = .white
            static let leadingSpacing: CGFloat = UIScreen.main.bounds.midX / 2
        }
        static let spacing: CGFloat = 10.0
    }
    
    @SwiftUI.Environment(\.presentationMode) var presentationMode
    let store: StoreOf<BeerDetails>
    let animation: Namespace.ID
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                beerImage(viewStore.beer.imageUrl, beerId: viewStore.beer.id, showImage: viewStore.showImage)
                VStack {
                    navBar(backButtonAction: { viewStore.send(.onDisappear) },
                           rightButton: favButton(viewStore.isFavourite,
                                                  action: { viewStore.send(.toggleFavourite) }))
                    HStack {
                        Spacer(minLength: Constants.Background.leadingSpacing)
                        VStack(alignment: .leading, spacing: Constants.spacing) {
                            Text(viewStore.beer.tagline.replacingOccurrences(of: String.dot, with: String.empty))
                                .font(Constants.Tagline.font)
                                .fontWeight(Constants.Tagline.fontWeight)
                                .opacity(Constants.Tagline.opacity)
                            Text(viewStore.beer.name)
                                .font(Constants.Title.font)
                                .bold()
                            ScrollView(showsIndicators: false) {
                                VStack(alignment: .leading, spacing: Constants.spacing) {
                                    descriptionSection(viewStore.beer.description)
                                    statsSection(viewStore.beer.abv, viewStore.beer.ibu, viewStore.beer.ebc)
                                    if let brewersTips = viewStore.beer.brewersTips {
                                        brewersTipsSection(brewersTips)
                                    }
                                }
                            }
                            .padding(.top, 20.0)
                        }
                        .padding([.top, .horizontal])
                    }
                }
            }
            .background(
                Rectangle()
                    .fill(Constants.Background.color)
                    .ignoresSafeArea()
            )
            .onAppear {
                viewStore.send(.onAppear, animation: .interactiveSpring(response: Constants.Animation.response,
                                                                        dampingFraction: Constants.Animation.dampingFraction,
                                                                        blendDuration: Constants.Animation.blendDuration))
            }
        }
        .navigationBarHidden(true)
    }
    
    @ViewBuilder
    private func navBar(backButtonAction: @escaping () -> Void, rightButton: some View) -> some View {
        HStack {
            Button {
                backButtonAction()
                withAnimation(.easeIn(duration: Constants.Animation.duration)) {
                    presentationMode.wrappedValue.dismiss()
                }
            } label: {
                Icons.leftArrow.value
            }
            Spacer()
            rightButton
        }
        .font(Constants.NavBar.font)
        .fontWeight(Constants.NavBar.fontWeight)
        .foregroundColor(Constants.NavBar.color)
        .padding(.horizontal, Constants.NavBar.horizontalPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func favButton(_ isFavourite: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: isFavourite ? Icons.heartFill.name : Icons.heart.name)
        }
    }
    
    @ViewBuilder
    private func beerImage(_ url: String?, beerId: Int, showImage: Bool) -> some View {
        ZStack {
            Circle()
                .fill(Constants.Circle.color)
                .offset(x: Constants.Circle.additionalXOffset)
            if showImage {
                CachedAsyncImage(url: URL(string: url ?? .empty)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: .infinity)
                        .padding(Constants.Image.padding)
                        .shadow(radius: Constants.Image.shadowRadius)
                        .matchedGeometryEffect(id: "\(beerId)/\(String(describing: url))", in: animation)
                } placeholder: {
                    ProgressView()
                }
            }
        }
        .offset(x: Constants.Image.xOffset)
    }
    
    @ViewBuilder
    private func titleText(_ title: String) -> some View {
        Text(title)
            .fontWeight(Constants.Title.fontWeight)
            .underline()
    }
    
    @ViewBuilder
    private func descriptionSection(_ description: String) -> some View {
        Group {
            titleText(Localizable.descriptionSectionTitleBeerDetailView.value)
            Text(description)
                .foregroundColor(Constants.ContentText.color)
        }
        .padding(.leading, 35.0)
        .padding(.trailing, 10.0)
    }
    
    @ViewBuilder
    private func statsSection(_ abv: Double, _ ibu: Double?, _ ebc: Double?) -> some View {
        Group {
            titleText(Localizable.parametersSectionTitleBeerDetailView.value)
            StatLevelView(statKind: .abv, value: abv)
            StatLevelView(statKind: .ibu, value: ibu)
            StatLevelView(statKind: .ebc, value: ebc)
        }
        .padding(.leading, 35.0)
    }
    
    @ViewBuilder
    private func brewersTipsSection(_ text: String) -> some View {
        Group {
            titleText(Localizable.brewerTipsSectionTitleBeerDetailView.value)
            Text(text)
                .foregroundColor(Constants.ContentText.color)
        }
        .padding(.leading, 35.0)
    }
    
}

struct BeerDetailView_Previews: PreviewProvider {
    @Namespace static var animation
    
    static var previews: some View {
        BeerDetailView(store: Store(initialState: BeerDetails.State(id: UUID(),
                                                                    beer: Beer.mock),
                                    reducer: BeerDetails()),
                       animation: animation)
    }
}
