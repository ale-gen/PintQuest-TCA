//
//  Localizable.swift
//  PintQuest-TCA
//
//  Created by Aleksandra Generowicz on 29/04/2023.
//

import Foundation

protocol Translation {
    var value: String { get }
}

extension Translation where Self: RawRepresentable, Self.RawValue == String {
    
    var value: String {
        return NSLocalizedString(rawValue, comment: .empty)
    }
    
}

enum Localizable: String, Translation {
   
    // MARK: Navigation bar titles
    case homeNavigationBarTitle = "home.navigation.bar.title"
    
    // MARK: Search bars
    case beerSearchBarPrompt = "beer.search.bar.prompt"
    
    // MARK: Menu tab titles
    case browseMenuTabTitle = "browse.menu.tab.title"
    case favouriteMenuTabTitle = "favourite.menu.tab.title"
    
    // MARK: Vital stats
    case abvFullnameText = "abv.fullname.text"
    case ibuFullnameText = "ibu.fullname.text"
    case ebcFullnameText = "ebc.fullname.text"
    case abvShortnameText = "abv.shortname.text"
    case ibuShortnameText = "ibu.shortname.text"
    case ebcShortnameText = "ebc.shortname.text"
    
    // MARK: Beer detail view section titles
    case descriptionSectionTitleBeerDetailView = "description.section.title.beer.details.view"
    case parametersSectionTitleBeerDetailView = "parameters.section.title.beer.details.view"
    case brewerTipsSectionTitleBeerDetailView = "brewer.tips.section.title.beer.details.view"
    
    // MARK: Beer card
    case brewedFromTitleBeerCard = "brewed.from.title.beer.card"
    
    // MARK: Searched beers collection
    case emptyStateTitleBrowseBeersCollection = "empty.state.title.browse.beers.collection"
    case emptyStateButtonTitleBrowseBeersCollection = "empty.state.button.title.browse.beers.collection"
    
    // MARK: Fav beers collection
    case emptyStateTitleFavBeersCollection = "empty.state.title.fav.beers.collection"
    case emptyStateButtonTitleFavBeersCollection = "empty.state.button.title.fav.beers.collection"

}
