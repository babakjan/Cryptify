//
//  TradeAPI.swift
//  Cryptify
//
//  Created by Jan Babák on 10.12.2022.
//

import Foundation

//api endpoint documentation https://docs.poloniex.com/#public-endpoints-market-data-trades

final class TradeAPI: API<Trade> {
    
    @MainActor
    func fetchAllTrades(symbolId: String) async -> [Trade] {
        return await fetchAll(path: "/\(symbolId)/trades", parameters: [Parameter.limit: "20"])
    }
}
