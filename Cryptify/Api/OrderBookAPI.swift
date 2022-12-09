//
//  OrderBookAPI.swift
//  Cryptify
//
//  Created by Jan Babák on 01.12.2022.
//

import Foundation

//api endpoint documentation https://docs.poloniex.com/#public-endpoints-market-data-order-book

final class OrderBookAPI: API<OrderBook> {
    
    @MainActor
    func fetchOrderBook(symbolId: String) async -> OrderBook? {
        return await fetch(path: "/\(symbolId)/orderBook", parameters: [Parameter.limit: "20"])
    }
}
