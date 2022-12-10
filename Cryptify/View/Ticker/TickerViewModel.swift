//
//  TickerViewModel.swift
//  Cryptify
//
//  Created by Jan Babák on 22.11.2022.
//

import Foundation
import SwiftUI

final class TickerViewModel: ObservableObject {
    
    @Published private(set) var ticker: Ticker? = nil
    @Published private(set) var symbol: Symbol? = nil
    @Published private(set) var candles: [Candle] = []
    @Published private(set) var orderBook: OrderBook? = nil
    @Published private var selectedChartHelper = ChartType.area
    @Published var selectedInterval = Interval.all
    
    private let symbolId: String
    private let tickerApi: TickerAPI = .init()
    private let symbolApi: SymbolAPI = .init()
    private let candleApi: CandleAPI = .init()
    private let orderBookApi: OrderBookAPI = .init()
    
    var selectedChart: ChartType { //because of the animation
        get { selectedChartHelper }
        set {
            withAnimation(.easeInOut(duration: 0.5)) {
                selectedChartHelper = newValue
            }
        }
    }
    
    //red if start is greater than end, green if start is lower than end
    var graphColor: Color {
        !candles.isEmpty && candles.last!.close - candles.first!.close < 0 ? Color.theme.red : Color.theme.green
    }
    
    //min close value in candles array adjusted in order to fit better in chart
    var candlesAdjustedMinClose: Double? {
        0.99998 * (candles.min(by: { $0.close < $1.close })?.close ?? 0)
    }
    
    //max close value in candles array adjusted in order to fit better in chart
    var candlesAdjustedMaxClose: Double? {
        1.00005 * (candles.max(by: { $0.close < $1.close })?.close ?? 0)
    }
    
    init(symbolId: String) {
        self.symbolId = symbolId
    }
    
    @MainActor
    func fetchData(animate: Bool = true) async {
        (ticker, symbol, candles, orderBook) = await (
            tickerApi.fetchTicker(symbolId: symbolId),
            symbolApi.fetchSymbol(symbolId: symbolId),
            candleApi.fetchAllCandles(symbolId: symbolId, interval: selectedInterval),
            orderBookApi.fetchOrderBook(symbolId: symbolId)
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
        candles = await candleApi.fetchAllCandles(symbolId: symbolId, interval: selectedInterval)
    }
    
    @MainActor
    func fetchOrderBook() async {
        orderBook = await orderBookApi.fetchOrderBook(symbolId: symbolId)
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
        case area = "Area"
        case line = "Line"
        case candles = "Candles"
        
        var id: String {
            self.rawValue
        }
    }
    
    enum Interval: String, CaseIterable, Identifiable {
        case all = "All"
        case years10 = "10Y"
        case years5 = "5Y"
        case years2 = "2Y"
        case year1 = "1Y"
        case month6 = "6M"
        case month3 = "3M"
        case month1 = "1M"
        case week1 = "1W"
        case day1 = "1D"
        case hour1 = "1H"
        case minut30 = "30m"
        
        var id: String {
            self.rawValue
        }
    }
}
