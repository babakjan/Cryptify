//
//  Symbol.swift
//  Cryptify
//
//  Created by Jan Babák on 19.11.2022.
//

import Foundation

//symbol - currency, not contain many details
struct Symbol: Hashable {
    var symbol: String //symbol name
    var firstCurrency: String //first currency from pair
    var secondCurrency: String //second currency from pair
    var price: Double //current price
    var time: UInt64 //time the record was created
    var dailyChange: Double //dayli change in decimal
    var ts: UInt64 //time the record was published
    
    var formattedDailyChange: String {
        formattTwoDecimalsPercent(number: dailyChange)
    }
    
    var formattedPrice: String {
        formattPrice(of: price, maxNumberOfDigits: 9)
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
