//
//  Symbol.swift
//  Cryptify
//
//  Created by Jan Babák on 19.11.2022.
//

import Foundation

struct Symbol {
    var symbol: String //symbol name
    var firstCurrency: String //first currency from pair
    var secondCurrency: String //second currency from pair
    var price: Double //current price
    var time: UInt64 //time the record was created
    var dailyChange: Double //dayli change in decimal
    var ts: UInt64 //time the record was published
    
    //return formatted daily change - in format 44,90% - 2 decimal digits and with % sign
    var formattedDailyChange: String {
        "\(String(format: "%.2f", ceil(dailyChange * 100) / 100))%"
    }
    
    //return formatted price - in format $5345.4353, max number of digits is 9
    var formattedPrice: String {
        let maxNumberOfDigits = 9 //decimal + not decimal
        let maximumFractionDigits = maxNumberOfDigits - price.description.components(separatedBy: ".")[0].count //maxNumberOfDigits - num of non decimal digits
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = maximumFractionDigits > 0 ? maximumFractionDigits : 0
        return "$\(formatter.string(from: NSNumber(value: price))!)"
    }
}

extension Symbol: Decodable {
    enum CodingKeys: String, CodingKey {
        case symbol
        case price
        case time
        case dailyChange
        case ts
    }
    
    //decode API response
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.symbol = try container.decode(String.self, forKey: .symbol)
        let currencies = self.symbol.components(separatedBy: "_")
        self.firstCurrency = currencies[0]
        self.secondCurrency = currencies[1]
        let price = try container.decode(String.self, forKey: .price)
        self.price = Double(price)!
        self.time = try container.decode(UInt64.self, forKey: .time)
        let dailyChange = try container.decode(String.self, forKey: .dailyChange)
        self.dailyChange = Double(dailyChange)!
        self.ts = try container.decode(UInt64.self, forKey: .ts)
    }
}
