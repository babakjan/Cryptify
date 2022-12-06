//
//  Formatter.swift
//  Cryptify
//
//  Created by Jan Babák on 22.11.2022.
//

import Foundation

//return formatted price - in format 5345.4353
func formattPrice(of price: Double, maxNumberOfDigits: Int = 8) -> String {
    let maximumFractionDigits = maxNumberOfDigits - price.description.components(separatedBy: ".")[0].count //maxNumberOfDigits - num of non decimal digits
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = maximumFractionDigits > 0 ? maximumFractionDigits : 0
    formatter.decimalSeparator = "."
    return "\(formatter.string(from: NSNumber(value: price))!)"
}

func formattTwoDecimals(number: Double) -> String {
    String(format: "%.2f", ceil(number * 100) / 100)
}

func formattTwoDecimalsPercent(number: Double) -> String {
    "\(String(format: "%.2f", ceil(number * 100) / 100))%"
}
