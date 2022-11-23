//
//  TickerViewModel.swift
//  Cryptify
//
//  Created by Jan Babák on 22.11.2022.
//

import Foundation

final class TickerViewModel: ObservableObject {
    
    @Published var ticker: Ticker? = nil
    @Published var symbol: Symbol? = nil
    @Published var candles: [Candle] = []
    @Published var selectedChart = ChartType.candles
    
    let chartTypeOptions = [
        ChartType.candles,
        ChartType.line,
        ChartType.area
    ]
    
    private let symbolId: String
    private let tickerApi: TickerAPI = .init()
    private let symbolApi: SymbolAPI = .init()
    private let candleApi: CandleAPI = .init()
    
    init(symbolId: String) {
        self.symbolId = symbolId
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
        candles = await candleApi.fetchAllCandles(symbolId: symbolId)
    }
    
    enum ChartType: String, CaseIterable, Identifiable {
        case candles
        case line
        case area
        
        var id: String {
            self.rawValue
        }
    }
}
