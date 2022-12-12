//
//  TickerAPI.swift
//  Cryptify
//
//  Created by Jan Babák on 22.11.2022.
//

import Foundation

//api endpoint documentation https://docs.poloniex.com/#public-endpoints-market-data-ticker

final class TickerAPI: API<Ticker> {
    
    func fetchTicker(symbolId: String) async throws -> Ticker? {
        return try await fetch(path: "/\(symbolId)/ticker24h")
    }
}
