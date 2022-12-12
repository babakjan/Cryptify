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
    @Published private var selectedChartHelper = ChartType.area
    @Published var selectedInterval = Interval.all
    @Published var displayedViewHelper = DisplayedView.trades
    private var tradesInRowFails = 0 //number of failed requests in a row of trades
    private var orderBookInRowFails = 0 //number of failed requests in a row of order book
    static let maxNumberOfAutoReloadTrys = 3 //if auto realoading request fails more than this times in a row, stop trying
    
    private let symbolId: String
    private let tickerApi: TickerAPI = .init()
    private let symbolApi: SymbolAPI = .init()
    private let candleApi: CandleAPI = .init()
    private let orderBookApi: OrderBookAPI = .init()
    private let tradeApi: TradeAPI = .init()
    
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
    
    func fetchData() async {
            await fetchTicker()
            await fetchSymbol()
            await fetchCandles()
            await fetchTrades()
            await fetchOrderBook()
        
        DispatchQueue.main.async {
            self.animateChart()
        }
    }
    
    @MainActor
    func fetchTicker() async {
        tickerState = .loading
        
        do {
            ticker = try await tickerApi.fetchTicker(symbolId: symbolId)
        } catch {
            print("[ERROR] fetch ticker ticker view model")
            tickerState = .error(message: error.localizedDescription)
            return
        }
        
        tickerState = .ok
    }

    @MainActor
    func fetchSymbol() async {
        symbolState = .loading
        
        do {
            symbol = try await symbolApi.fetchSymbol(symbolId: symbolId)
        } catch {
            print("[ERROR] fetch symbol ticker view model")
            symbolState = .error(message: error.localizedDescription)
            return
        }
        
        symbolState = .ok
    }
    
    @MainActor
    func fetchCandles() async {
        candlesState = .loading
        
        do {
            candles = try await candleApi.fetchAllCandles(symbolId: symbolId, interval: selectedInterval)
        } catch {
            print("[ERROR] fetch candles ticker view model")
            candlesState = .error(message: error.localizedDescription)
            return
        }
        
        candlesState = .ok
    }
    
    @MainActor
    func fetchOrderBook() async {
        orderBookState = .loading
        
        do {
            orderBook = try await orderBookApi.fetchOrderBook(symbolId: symbolId)
        } catch {
            print("[ERROR] fetch order book ticker view model")
            orderBookInRowFails += 1
            orderBookState = .error(message: error.localizedDescription)
            return
        }
        
        orderBookInRowFails = 0
        orderBookState = .ok
    }
    
    @MainActor
    func fetchTrades() async {
        tradesState = .loading
        
        do {
            trades = try await tradeApi.fetchAllTrades(symbolId: symbolId)
        } catch {
            print("[ERROR] fetch trades ticker view model")
            tradesInRowFails += 1
            tradesState = .error(message: error.localizedDescription)
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
    
    //which subview is displayed in ticker detail view
    enum DisplayedView: String, CaseIterable, Identifiable {
        case trades = "Trades"
        case orderBook = "OrderBook"
        
        var id: String {
            return self.rawValue
        }
    }
}
