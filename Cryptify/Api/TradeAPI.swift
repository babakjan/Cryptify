//
//  TradeAPI.swift
//  Cryptify
//
//  Created by Jan Babák on 10.12.2022.
//

import Foundation

//api endpoint documentation https://docs.poloniex.com/#public-endpoints-market-data-trades

//singleton API for Trade
final class TradeAPI: API {
    
    static let shared = TradeAPI()
    
    private override init() {} //sigleton hasn't accessible constructor

    func fetchAllTrades(symbolId: String) async throws -> [Trade] {
        return try await fetch(path: "/\(symbolId)/trades", parameters: [Parameter.limit: "20"]) ?? []
    }
}
