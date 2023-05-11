//
//  Icons.swift
//  PintQuest-TCA
//
//  Created by Aleksandra Generowicz on 29/04/2023.
//

import SwiftUI

protocol IconTranslation {
    var value: Image { get }
}

extension IconTranslation where Self: RawRepresentable, Self.RawValue == String {
    var value: Image {
        return Image(systemName: rawValue)
    }
    
    var name: String {
        return rawValue
    }
}

enum Icons: String, IconTranslation {
    case boltFill = "bolt.fill"
    case circleFill = "circle.fill"
    case leftArrow = "chevron.left"
    case rightArrow = "chevron.right"
    case heart = "heart"
    case heartFill = "heart.fill"
}
