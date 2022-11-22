//
//  TickerViewModel.swift
//  Cryptify
//
//  Created by Jan Babák on 22.11.2022.
//

import Foundation

final class TickerViewModel: ObservableObject {
    let symbolId: String
    @Published var ticker: Ticker? = nil
    @Published var symbol: Symbol? = nil
    let tickerApi: API<Ticker> = .init()
    let symbolApi: API<Symbol> = .init()
    
    init(symbol: String) {
        self.symbolId = symbol
    }
    
    @MainActor
    func fetchTicker() async {
        ticker = await tickerApi.fetch(url: "/\(symbolId)/ticker24h")
    }
    
    @MainActor
    func fetchSymbol() async {
        symbol = await symbolApi.fetch(url: "/\(symbolId)/price")
    }
}
