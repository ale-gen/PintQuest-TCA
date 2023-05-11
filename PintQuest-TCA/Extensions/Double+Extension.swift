//
//  Double+Extension.swift
//  PintQuest-TCA
//
//  Created by Aleksandra Generowicz on 29/04/2023.
//

import Foundation

extension Double {
    
    func scale(from input: ClosedRange<Double>, to output: ClosedRange<Double>) -> Self {
        let x = (output.upperBound - output.lowerBound) * (self - input.lowerBound)
        let y = (input.upperBound - input.lowerBound)
        return x / y + output.lowerBound
    }
    
}
