//
//  Ticker.swift
//  Cryptify
//
//  Created by Jan Babák on 21.11.2022.
//

import Foundation

//Ticker - currency detail
struct Ticker: Hashable {
    var symbol: String //symbol name
    var open: Double //price at the start time
    var close: Double //price at the end time
    var low: Double //lowest price over the last 24h
    var high: Double //hightest price over the last 24h
    var quantity: Double //base units traded over last 24h
    var amount: Double //quote units traded over last 24h
    var tradeCount: Int //count of trades
    var startTime: UInt64 //start time for the 24h interval
    var closeTime: UInt64 //close time for the 24 interval
    var displayName: String //symbol display name
    var dailyChange: Double //daily change in decimal
    var ts: UInt64 //time recordd was pushed
    
    var formattedOpen: String {
        Formatter.shared.formatToNumberOfdigits(of: open)
    }
    
    var formattedClose: String {
        Formatter.shared.formatToNumberOfdigits(of: close)
    }
    
    var formattedLow: String {
        Formatter.shared.formatToNumberOfdigits(of: low)
    }
    
    var formattedHigh: String {
        Formatter.shared.formatToNumberOfdigits(of: high)
    }

    var formattedQuantity: String {
        Formatter.shared.formattTwoDecimals(number: quantity)
    }
    
    var formattedAmount: String {
        Formatter.shared.formattTwoDecimals(number: amount)
    }
}

extension Ticker: Decodable {
    enum CodingKeys: String, CodingKey {
        case symbol
        case open
        case close
        case low
        case high
        case quantity
        case amount
        case tradeCount
        case startTime
        case closeTime
        case endTime
        case displayName
        case dailyChange
        case ts
    }
    
    //decode API response
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.symbol = try container.decode(String.self, forKey: .symbol)
        let open = try container.decode(String.self, forKey: .open)
        self.open = Double(open)!
        let close = try container.decode(String.self, forKey: .close)
        self.close = Double(close)!
        let low = try container.decode(String.self, forKey: .low)
        self.low = Double(low)!
        let high = try container.decode(String.self, forKey: .high)
        self.high = Double(high)!
        let quantity = try container.decode(String.self, forKey: .quantity)
        self.quantity = Double(quantity)!
        let amount = try container.decode(String.self, forKey: .amount)
        self.amount = Double(amount)!
        self.tradeCount = try container.decode(Int.self, forKey: .tradeCount)
        self.startTime = try container.decode(UInt64.self, forKey: .startTime)
        self.closeTime = try container.decode(UInt64.self, forKey: .closeTime)
        self.displayName = try container.decode(String.self, forKey: .displayName)
        let dailyChange = try container.decode(String.self, forKey: .dailyChange)
        self.dailyChange = Double(dailyChange)!
        self.ts = try container.decode(UInt64.self, forKey: .ts)
    }
}
