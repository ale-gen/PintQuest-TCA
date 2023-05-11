//
//  BeerVitalStat.swift
//  PintQuest-TCA
//
//  Created by Aleksandra Generowicz on 29/04/2023.
//

import SwiftUI

enum BeerVitalStat {
    case abv
    case ibu
    case ebc
    
    var fullName: String {
        switch self {
        case .abv:
            return Localizable.abvFullnameText.value
        case .ibu:
            return Localizable.ibuFullnameText.value
        case .ebc:
            return Localizable.ebcFullnameText.value
        }
    }
    
    var shortName: String {
        switch self {
        case .abv:
            return Localizable.abvShortnameText.value
        case .ibu:
            return Localizable.ibuShortnameText.value
        case .ebc:
            return Localizable.ebcShortnameText.value
        }
    }
    
    var range: ClosedRange<Double> {
        switch self {
        case .abv:
            return 0...100
        case .ibu:
            return 1...150
        case .ebc:
            return 1...85
        }
    }
    
    var icon: Image? {
        switch self {
        case .abv:
            return nil
        case .ibu:
            return Icons.boltFill.value
        case .ebc:
            return Icons.circleFill.value
        }
    }
    
}
