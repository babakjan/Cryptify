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
    @Published var selectedChartHelper = ChartType.line
    var selectedChart: ChartType { //because of the animation
        get { selectedChartHelper }
        set {
            withAnimation(.easeInOut(duration: 0.5)) {
                selectedChartHelper = newValue
            }
        }
    }
    
    private let symbolId: String
    private let tickerApi: TickerAPI = .init()
    private let symbolApi: SymbolAPI = .init()
    private let candleApi: CandleAPI = .init()
    
    init(symbolId: String) {
        self.symbolId = symbolId
    }
    
    var graphColor: Color {
        !candles.isEmpty && candles.last!.close - candles.first!.close < 0 ? Color.theme.red : Color.theme.green
    }
    
    @MainActor
    func fetchData(animate: Bool = true) async {
        (ticker, symbol, candles) = await (
            tickerApi.fetchTicker(symbolId: symbolId),
            symbolApi.fetchSymbol(symbolId: symbolId),
            candleApi.fetchAllCandles(symbolId: symbolId)
        )
        
        if animate {
            DispatchQueue.main.async {
                self.animateChart()
            }
        }
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
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.007) {
                withAnimation(.interactiveSpring(response: 1.1, dampingFraction: 1.1, blendDuration: 1.1)) {
                    self.candles[index].animate = true
                }
            }
        }
    }
    
    enum ChartType: String, CaseIterable, Identifiable {
        case line
        case area
        case candles
        
        var id: String {
            self.rawValue
        }
    }
}
