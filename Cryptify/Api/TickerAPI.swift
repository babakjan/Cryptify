//
//  TickerAPI.swift
//  Cryptify
//
//  Created by Jan Babák on 22.11.2022.
//

import Foundation

//api endpoint documentation https://docs.poloniex.com/#public-endpoints-market-data-ticker

class TickerAPI: API<Ticker> {
    
    @MainActor
    func fetchTicker(symbolId: String) async -> Ticker? {
        return await fetch(path: "/\(symbolId)/ticker24h")
    }
}
