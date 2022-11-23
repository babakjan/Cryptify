//
//  TickerAPI.swift
//  Cryptify
//
//  Created by Jan Babák on 22.11.2022.
//

import Foundation

class TickerAPI: API<Ticker> {
    
    @MainActor
    func fetchTicker(symbolId: String) async -> Ticker? {
        return await fetch(path: "/\(symbolId)/ticker24h")
    }
}
