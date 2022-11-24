//
//  TickerViewModel.swift
//  Cryptify
//
//  Created by Jan Babák on 22.11.2022.
//

import Foundation
import SwiftUI

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
    
    var graphColor: Color {
        !candles.isEmpty && candles.last!.openCloseAvg - candles.first!.openCloseAvg < 0 ? Color.theme.red : Color.theme.green
    }
    
    @MainActor
    func fetchData() async {
        (ticker, symbol, candles) = await (
            tickerApi.fetchTicker(symbolId: symbolId),
            symbolApi.fetchSymbol(symbolId: symbolId),
            candleApi.fetchAllCandles(symbolId: symbolId)
        )
        //TODO choose nicer way
        
//        await fetchCandles()
//        await fetchSymbol()
//        await fetchTicker()
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
    
    //animate chart
    func animateChart() {
        if !self.candles.isEmpty && self.candles.first!.animate {
            return //already animated
        }
        for (index, _) in candles.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.01) {
                withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    self.candles[index].animate = true
                }
            }
        }
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
