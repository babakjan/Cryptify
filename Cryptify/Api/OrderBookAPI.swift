//
//  OrderBookAPI.swift
//  Cryptify
//
//  Created by Jan Babák on 01.12.2022.
//

import Foundation

final class OrderBookAPI: API<OrderBook> {
    
    @MainActor
    func fetchOrderBook(symbolId: String) async -> OrderBook? {
        return await fetch(path: "/\(symbolId)/orderBook", parameters: ["limit": "20"])
    }
}
