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
    @Published var candles: [Candle] = []
    
    let tickerApi: TickerAPI = .init()
    let symbolApi: SymbolAPI = .init()
    let candleApi: CandleAPI = .init()
    
    init(symbol: String) {
        self.symbolId = symbol
    }
    
    @MainActor
    func fetchTicker() async {
        ticker = await tickerApi.fetchTicker(symbolId: symbolId)
    }

    @MainActor
    func fetchSymbol() async {
        symbol = await symbolApi.fetchSymbol(symbolId: symbolId)
    }
    
    @MainActor
    func fetchCandles() async {
        candles = await candleApi.fetchAllCandles(symbolId: symbolId, interval: .MONTH_1)
    }
}
