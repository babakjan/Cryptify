//
//  OrderBook.swift
//  Cryptify
//
//  Created by Jan Babák on 01.12.2022.
//

import Foundation

struct OrderBook: Hashable {
    var asks: [PriceAmountPair]
    var bids: [PriceAmountPair]
}

struct PriceAmountPair: Hashable {
    var price: Double
    var amount: Double
}

extension OrderBook: Decodable {
    enum CodingKeys: String, CodingKey {
        case asks
        case bids
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.asks = []
        self.bids = []
        
        let asks = try container.decode([String].self, forKey: .asks)
        let bids = try container.decode([String].self, forKey: .bids)
        
        guard asks.count % 2 == 0 && bids.count % 2 == 0 else { return }

        for i in stride(from: 0, through: asks.count - 1, by: 2) {
            self.asks.append(PriceAmountPair(price: Double(asks[i])!, amount: Double(asks[i + 1])!))
        }
        
        for i in stride(from: 0, through: bids.count - 1, by: 2) {
            self.bids.append(PriceAmountPair(price: Double(bids[i])!, amount: Double(bids[i + 1])!))
        }
    }
}
