//
//  Trade.swift
//  Cryptify
//
//  Created by Jan Babák on 10.12.2022.
//

import Foundation

//api endpoint documentation https://docs.poloniex.com/#public-endpoints-market-data-trades

struct Trade: Identifiable, Hashable {
    var id: String //trade id
    var price: Double //trade price
    var quantity: Double //base units traded
    var amount: Double //quote units traded
    var takerSide: TakerSide //buy or sell
}

extension Trade: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case price
        case quantity
        case amount
        case takerSide
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        let price = try container.decode(String.self, forKey: .price)
        self.price = Double(price)!
        let quantity = try container.decode(String.self, forKey: .quantity)
        self.quantity = Double(quantity)!
        let amount = try container.decode(String.self, forKey: .amount)
        self.amount = Double(amount)!
        let takerSide = try container.decode(String.self, forKey: .takerSide)
        self.takerSide = takerSide == "SELL" ? TakerSide.sell : TakerSide.buy
    }
}

enum TakerSide {
    case buy
    case sell
}
