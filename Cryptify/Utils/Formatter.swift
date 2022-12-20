//
//  Formatter.swift
//  Cryptify
//
//  Created by Jan Babák on 22.11.2022.
//

import Foundation

//singleton class for formatting prices and numbers
final class Formatter {
    static let shared = Formatter()
    
    private let numberFormatter: NumberFormatter
    
    private init() { //sigleton hasn't accessible constructor
        numberFormatter = NumberFormatter()
    }
    
    //return formatted price to requested max number of digits, if formatting will result into 0.000...1 number become zero, return it in exponent (scientific format)
    func formatToNumberOfdigits(of price: Double, maxNumberOfDigits: Int = 8) -> String {
        //maxNumberOfDigits minus num of non decimal digits
        let maximumFractionDigits = maxNumberOfDigits - price.description.components(separatedBy: ".")[0].count
        
        numberFormatter.maximumFractionDigits = maximumFractionDigits > 0 ? maximumFractionDigits : 0
        
        if let firstNonZero = firstNonZeroDigit(of: price), firstNonZero > maximumFractionDigits {
            numberFormatter.numberStyle = .scientific
            numberFormatter.exponentSymbol = "e"
            return numberFormatter.string(from: NSNumber(value: price)) ?? ""
        } else {
            numberFormatter.numberStyle = .decimal
            numberFormatter.decimalSeparator = "."
            return numberFormatter.string(from: NSNumber(value: price)) ?? ""
        }
        
    }
    
    func formattTwoDecimals(number: Double) -> String {
        String(format: "%.2f", ceil(number * 100) / 100)
    }

    func formattTwoDecimalsPercent(number: Double) -> String {
        "\(String(format: "%.2f", ceil(number * 100) / 100))%"
    }
    
    //return index (indexing from 1) of first non decimal digit (for example 0.001 -> 4)
    private func firstNonZeroDigit(of price: Double) -> Int? {
        var i = 1
        var price = price
        while i < 50 {
            if floor(price) > 0 {
                return i
            }
            price *= 10
            i += 1
        }
        return nil
    }
}
