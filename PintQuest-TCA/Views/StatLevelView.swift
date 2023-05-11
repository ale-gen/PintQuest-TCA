//
//  StatLevelView.swift
//  PintQuest-TCA
//
//  Created by Aleksandra Generowicz on 29/04/2023.
//

import SwiftUI

struct StatLevelView: View {
    
    private enum Constants {
        static let defaultColor: Color = .darkBrown
        static let placeholderColor: Color = .gray.opacity(0.5)
        static let range: ClosedRange<Double> = 1...5
        static let spacing: CGFloat = 5.0
        enum Text {
            static let font: Font = .system(size: 12.0)
            static let fontWeight: Font.Weight = .semibold
        }
    }
    
    var statKind: BeerVitalStat
    var value: Double?
    var color: Color = Constants.defaultColor
    var horizontal: Bool = false
    
    var body: some View {
        if horizontal {
            HStack {
                label
                result
            }
        } else {
            VStack(alignment: .leading, spacing: Constants.spacing) {
                label
                result
            }
        }
    }
    
    private var label: some View {
        Text(statKind.shortName)
            .font(.subheadline)
            .fontWeight(.medium)
    }
    
    private var result: some View {
        ZStack {
            if let icon = statKind.icon {
                HStack(spacing: Constants.spacing) {
                    ForEach(1...5, id: \.self) { index in
                        icon
                            .font(.caption2)
                            .foregroundColor(value?.scale(from: statKind.range, to: Constants.range) ?? .zero >= Double(index) ? color : Constants.placeholderColor)
                    }
                }
            } else {
                HStack(spacing: .zero) {
                    Text(value ?? .zero, format: .number)
                    Text(String.percentage)
                }
                .font(Constants.Text.font)
                .fontWeight(Constants.Text.fontWeight)
                .foregroundColor(color)
            }
        }
    }
}

struct StatLevelView_Previews: PreviewProvider {
    static var previews: some View {
        StatLevelView(statKind: .ibu,
                      value: 80.4)
    }
}

