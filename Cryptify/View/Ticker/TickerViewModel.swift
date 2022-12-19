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
    @Published private(set) var tickerState = ResourceState.ok
    @Published private(set) var symbol: Symbol? = nil
    @Published private(set) var symbolState = ResourceState.ok
    @Published private(set) var candles: [Candle] = []
    @Published private(set) var candlesState = ResourceState.ok
    @Published private(set) var orderBook: OrderBook? = nil
    @Published private(set) var orderBookState = ResourceState.ok
    @Published private(set) var trades: [Trade] = []
    @Published private(set) var tradesState = ResourceState.ok
    @Published var displayedViewHelper = DisplayedView.trades
    
    @AppStorage(TickerViewModel.selectedIntervalUserDefaultsKey) var selectedInterval = Interval.all
    @AppStorage(TickerViewModel.selectedChartUserDefaultsKey) private var selectedChartHelper = ChartType.area
    
    static let selectedIntervalUserDefaultsKey = "ChartDefaultInterval"
    static let selectedChartUserDefaultsKey = "selectedChart"
    static let maxNumberOfAutoReloadTrys = 3 //if auto realoading request fails more than this times in a row, stop trying
    
    private var tradesInRowFails = 0 //number of failed requests in a row of trades
    private var orderBookInRowFails = 0 //number of failed requests in a row of order book
    
    private let symbolId: String
    
    //setter using animation
    var selectedChart: ChartType {
        get { selectedChartHelper }
        set {
            withAnimation(.easeInOut(duration: 0.5)) {
                selectedChartHelper = newValue
            }
        }
    }
    
    //setter using animation
    var displayedView: DisplayedView {
        get { displayedViewHelper }
        set {
            withAnimation(.easeInOut(duration: 0.5)) {
                displayedViewHelper = newValue
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
    func fetchData() async {
        tickerState = .loading
        symbolState = .loading
        candlesState = .loading
        tradesState = .loading
        orderBookState = .loading
        
        await fetchTicker()
        await fetchSymbol()
        await fetchCandles()
        
        DispatchQueue.main.async {
            self.animateChart()
        }
        
        await fetchTrades()
        await fetchOrderBook()
    }
    
    @MainActor
    func fetchTicker() async {
        tickerState = .loading
        
        do {
            ticker = try await TickerAPI.shared.fetchTicker(symbolId: symbolId)
        } catch {
            print("[ERROR] fetch ticker ticker view model")
            tickerState = .error(messageLocalizedKey: error.localizedDescription)
            return
        }
        
        tickerState = .ok
    }

    @MainActor
    func fetchSymbol() async {
        symbolState = .loading
        
        do {
            symbol = try await SymbolAPI.shared.fetchSymbol(symbolId: symbolId)
        } catch {
            print("[ERROR] fetch symbol ticker view model")
            symbolState = .error(messageLocalizedKey: error.localizedDescription)
            return
        }
        
        symbolState = .ok
    }
    
    @MainActor
    func fetchCandles() async {
        candlesState = .loading
        
        do {
            candles = try await CandleAPI.shared.fetchAllCandles(symbolId: symbolId, interval: selectedInterval)
        } catch {
            print("[ERROR] fetch candles ticker view model")
            candlesState = .error(messageLocalizedKey: error.localizedDescription)
            return
        }
        
        candlesState = .ok
    }
    
    @MainActor
    func fetchOrderBook() async {
        orderBookState = .loading
        
        do {
            orderBook = try await OrderBookAPI.shared.fetchOrderBook(symbolId: symbolId)
        } catch {
            print("[ERROR] fetch order book ticker view model")
            orderBookInRowFails += 1
            orderBookState = .error(messageLocalizedKey: error.localizedDescription)
            return
        }
        
        orderBookInRowFails = 0
        orderBookState = .ok
    }
    
    @MainActor
    func fetchTrades() async {
        tradesState = .loading
        
        do {
            trades = try await TradeAPI.shared.fetchAllTrades(symbolId: symbolId)
        } catch {
            print("[ERROR] fetch trades ticker view model")
            tradesInRowFails += 1
            tradesState = .error(messageLocalizedKey: error.localizedDescription)
            return
        }
        
        tradesInRowFails = 0
        tradesState = .ok
    }
    
    //refresh currently displayed view
    func refreshDisplayedView() async {
        if displayedView == DisplayedView.trades && tradesInRowFails < Self.maxNumberOfAutoReloadTrys {
            await fetchTrades()
        } else if displayedView == DisplayedView.orderBook && orderBookInRowFails < Self.maxNumberOfAutoReloadTrys {
            await fetchOrderBook()
        }
    }
    
    //animate chart - look like chart is growing from bottom to top and from leading to trailing
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
        case area = "areaChart"
        case line = "lineChart"
        case candles = "candleChart"
        
        var id: String {
            self.rawValue
        }
    }
    
    enum Interval: String, CaseIterable, Identifiable {
        case all = "all"
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
    
    //which subview is displayed in ticker detail view
    enum DisplayedView: String, CaseIterable, Identifiable {
        case trades = "trades"
        case orderBook = "orderBook"
        
        var id: String {
            return self.rawValue
        }
    }
}
