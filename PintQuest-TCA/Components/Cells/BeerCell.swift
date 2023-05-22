//
//  BeerCell.swift
//  PintQuest-TCA
//
//  Created by Aleksandra Generowicz on 30/04/2023.
//

import SwiftUI
import CachedAsyncImage

struct BeerCell: View {
    
    private enum Constants {
        enum Image {
            static let cornerRadius: CGFloat = 10.0
            static let backgroundColor: Color = .beige
            static let shadowRadius: CGFloat = 10.0
            static let padding: CGFloat = 2.0
        }
        enum Background {
            static let cornerRadius: CGFloat = 10.0
            static let color: Color = .white
            static let shadowColor: Color = .black.opacity(0.08)
            static let shadowRadius: CGFloat = 8.0
            static let xShadow: CGFloat = 5.0
            static let yShadow: CGFloat = 5.0
        }
        enum Subtitle {
            static let font: Font = .subheadline
            static let fontWeight: Font.Weight = .light
            static let color: Color = .secondary
        }
    }
    
    let beer: Beer
    let animation: Namespace.ID
    var shouldHideImage: Bool
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            
            HStack(spacing: -10.0) {
                VStack(alignment: .leading, spacing: 5.0) {
                    HStack {
                        Text(beer.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    
                    Text(beer.tagline)
                        .font(Constants.Subtitle.font)
                        .foregroundColor(Constants.Subtitle.color)
                    
                    HStack {
                        StatLevelView(statKind: .ibu, value: beer.ibu)
                        Spacer()
                        StatLevelView(statKind: .abv, value: beer.abv)
                        Spacer()
                    }
                    .padding(.top, 10.0)
                    
                    Spacer(minLength: 2.0)
                    
                    HStack {
                        HStack(spacing: 1.0) {
                            Text(Localizable.brewedFromTitleBeerCard.value)
                            Text(beer.firstBrewed)
                        }
                        .font(Constants.Subtitle.font)
                        .fontWeight(Constants.Subtitle.fontWeight)
                        .foregroundColor(Constants.Subtitle.color)
                        Spacer()
                        Icons.rightArrow.value
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.trailing, 10.0)
                    }
                }
                .foregroundColor(.black)
                .padding(20.0)
                .frame(width: 2 * size.width / 3, height: 0.8 * size.height, alignment: .leading)
                .background {
                    RoundedRectangle(cornerRadius: Constants.Background.cornerRadius, style: .continuous)
                        .fill(Constants.Background.color)
                        .shadow(color: Constants.Background.shadowColor, radius: Constants.Background.shadowRadius, x: Constants.Background.xShadow, y: -Constants.Background.yShadow)
                        .shadow(color: Constants.Background.shadowColor, radius: Constants.Background.shadowRadius, x: -Constants.Background.xShadow, y: Constants.Background.yShadow)
                }
                
                ZStack {
                    if !shouldHideImage {
                        image(width: size.width / 3, height: size.height)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(width: size.width)
        }
        .frame(minHeight: 220.0)
    }
    
    private func image(width: CGFloat, height: CGFloat) -> some View {
        CachedAsyncImage(url: URL(string: beer.imageUrl ?? .empty)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: 0.8 * height)
                .clipShape(RoundedRectangle(cornerRadius: Constants.Image.cornerRadius, style: .continuous))
                .matchedGeometryEffect(id: "\(beer.id)/\(String(describing: beer.imageUrl))", in: animation)
                .padding(Constants.Image.padding)
                .background {
                    RoundedRectangle(cornerRadius: Constants.Image.cornerRadius)
                        .fill(Constants.Image.backgroundColor)
                        .shadow(radius: Constants.Image.shadowRadius)
                        .frame(width: width, height: height)
                }
        } placeholder: {
            ProgressView()
        }
    }
}


struct BeerRowView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        BeerCell(beer: Beer.mock,
                 animation: namespace,
                 shouldHideImage: false)
    }
}
