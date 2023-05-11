//
//  Beer.swift
//  PintQuest-TCA
//
//  Created by Aleksandra Generowicz on 29/04/2023.
//

import ComposableArchitecture
import SwiftUI

struct Beer: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let tagline: String
    let firstBrewed: String
    let description: String
    let abv: Double
    let ibu: Double?
    let ebc: Double?
    let imageUrl: String?
    let brewersTips: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case tagline
        case firstBrewed = "first_brewed"
        case description
        case abv
        case ibu
        case ebc
        case imageUrl = "image_url"
        case brewersTips = "brewers_tips"
    }
}

extension Beer {
    
    static let mock: Beer = .init(id: 2,
                                  name: "Trashy Blonde",
                                  tagline: "You Know You Shouldn\'t",
                                  firstBrewed: "04/2008",
                                  description: "A titillating, neurotic, peroxide punk of a Pale Ale. Combining attitude, style, substance, and a little bit of low self esteem for good measure; what would your mother say? The seductive lure of the sassy passion fruit hop proves too much to resist. All that is even before we get onto the fact that there are no additives, preservatives, pasteurization or strings attached. All wrapped up with the customary BrewDog bite and imaginative twist.",
                                  abv: 4.1,
                                  ibu: Optional(41.5),
                                  ebc: Optional(15.0),
                                  imageUrl: Optional("https://images.punkapi.com/v2/2.png"),
                                  brewersTips: Optional("Be careful not to collect too much wort from the mash. Once the sugars are all washed out there are some very unpleasant grainy tasting compounds that can be extracted into the wort."))
}
