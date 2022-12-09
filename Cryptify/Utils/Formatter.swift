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
    
    private init() {
        numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.decimalSeparator = "."
    }
    
    //return formatted price to requested max number of digits
    func formatPrice(of price: Double, maxNumberOfDigits: Int = 8) -> String {
        //maxNumberOfDigits minus num of non decimal digits
        let maximumFractionDigits = maxNumberOfDigits - price.description.components(separatedBy: ".")[0].count
        
        numberFormatter.maximumFractionDigits = maximumFractionDigits > 0 ? maximumFractionDigits : 0
        
        return "\(numberFormatter.string(from: NSNumber(value: price))!)"
    }
    
    func formattTwoDecimals(number: Double) -> String {
        String(format: "%.2f", ceil(number * 100) / 100)
    }

    func formattTwoDecimalsPercent(number: Double) -> String {
        "\(String(format: "%.2f", ceil(number * 100) / 100))%"
    }
}
