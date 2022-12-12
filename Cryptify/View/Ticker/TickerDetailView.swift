//
//  TickerDetailView.swift
//  Cryptify
//
//  Created by Jan Babák on 21.11.2022.
//

import SwiftUI

struct TickerDetailView: View {
    @Binding var navigationPath: [Symbol]
    @StateObject var tickerViewModel: TickerViewModel
    @StateObject var marketsViewModel: MarketsViewModel
    
    @State private var timer: Timer?
    
    init(symbol: String, navigationPath: Binding<[Symbol]>, marketsViewModel: MarketsViewModel) {
        self._tickerViewModel = StateObject(wrappedValue: TickerViewModel(symbolId: symbol))
        self._navigationPath = navigationPath
        self._marketsViewModel = StateObject(wrappedValue: marketsViewModel)
    }
    
    var body: some View {
        ScrollView {
            bodyContent
        }
        .task {
            await tickerViewModel.fetchData()
        }
        .refreshable {
            await tickerViewModel.fetchData()
        }
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 7, repeats: true, block: refreshDisplayedView)
        }
        .onDisappear() {
            if let timer { timer.invalidate() }
        }
    }
    
    private var bodyContent: some View {
        VStack {
            if tickerViewModel.tickerState == .loading || tickerViewModel.symbolState == .loading {
                ProgressView()
                    .progressViewStyle(.circular)
            } else if tickerViewModel.tickerState == .error(), case let .error(message) = tickerViewModel.tickerState {
                ErrorView(
                    paragraph: message,
                    showTryAgainButton: true,
                    tryAgainAction: tickerViewModel.fetchData
                )
            } else if tickerViewModel.symbolState == .error(), case let .error(message) = tickerViewModel.symbolState {
                ErrorView(
                    paragraph: message,
                    showTryAgainButton: true,
                    tryAgainAction: tickerViewModel.fetchData
                )
            } else {
                loadedContent
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                ToolbarHeaderView(icon: "xmark") {
                    navigationPath.removeAll()
                }
            }
        }
    }
    
    private var loadedContent: some View {
        VStack(alignment: .leading) {
            priceAndDailyChange
                .padding(.top, 8)
                
            chartControlls
            
            chart
                .padding(.bottom, 16)
            
            tickerDetails
                .padding(.bottom, 16)
            
            displayedViewPicker
                .padding(.bottom, 16)
            
            if tickerViewModel.displayedView == TickerViewModel.DisplayedView.trades {
                trades
            } else if tickerViewModel.displayedView == TickerViewModel.DisplayedView.orderBook {
                orderBook
            }
        }
        .navigationTitle(tickerViewModel.ticker?.displayName ?? "")
        .gesture(
            DragGesture(minimumDistance: 20, coordinateSpace: .local)
                .onEnded(onDragGesture)
        )
    }
    
    @ViewBuilder
    private var priceAndDailyChange: some View {
        if let symbol = tickerViewModel.symbol {
            PriceAndDailyChangeView(symbol: symbol)
        }
    }
    
    private var chartControlls: some View {
        HStack(spacing: 16) {
            chartTypePicker
            
            intervalPicker
        }.padding(.horizontal, 0)
    }
    
    @ViewBuilder
    private var chart: some View {
        if tickerViewModel.candlesState == .loading {
            ProgressView().progressViewStyle(.circular)
        } else if tickerViewModel.candlesState == .error(), case let .error(message) = tickerViewModel.candlesState {
            ErrorView(
                heading: "Chart's not available!",
                paragraph: message,
                showTryAgainButton: true,
                tryAgainAction: tickerViewModel.fetchCandles,
                showImage: false
            )
        } else {
            ChartView(viewModel: tickerViewModel)
        }
    }
    
    @ViewBuilder
    private var tickerDetails: some View {
        if let ticker = tickerViewModel.ticker {
            DetailsView(ticker: ticker)
        } else {
            ProgressView().progressViewStyle(.circular)
        }
    }
    
    @ViewBuilder
    private var trades: some View {
        if tickerViewModel.tradesState == .loading && tickerViewModel.trades.isEmpty {
            ProgressView().progressViewStyle(.circular)
        } else if tickerViewModel.tradesState == .error(), case let .error(message) = tickerViewModel.tradesState {
            ErrorView(
                heading: "Trades are not available!",
                paragraph: message,
                showTryAgainButton: true, tryAgainAction: tickerViewModel.fetchTrades,
                showImage: false
            )
        } else {
            TradesView(tickerViewModel: tickerViewModel)
        }
    }
    
    @ViewBuilder
    private var orderBook: some View {
        if tickerViewModel.orderBookState == .loading && tickerViewModel.orderBook == nil {
            ProgressView().progressViewStyle(.circular)
        } else if tickerViewModel.orderBookState == .error(), case let .error(message) = tickerViewModel.orderBookState {
            ErrorView(
                heading: "Order Book isn't available!",
                paragraph: message,
                showTryAgainButton: true,
                tryAgainAction: tickerViewModel.fetchOrderBook,
                showImage: false
            )
        } else {
            OrderBookView(tickerViewModel: tickerViewModel)
        }
    }

    private var chartTypePicker: some View {
        Picker("Chart type", selection: $tickerViewModel.selectedChart) {
            ForEach(TickerViewModel.ChartType.allCases) { chartType in
                Text(chartType.rawValue)
                    .tag(chartType)
            }
        }
        .onChange(of: tickerViewModel.selectedChart) { newValue in
            SoundManager.instance.playTab()
        }
        .padding(.horizontal, -11)
    }
    
    private var intervalPicker: some View {
        Picker("Interval", selection: $tickerViewModel.selectedInterval) {
            ForEach(TickerViewModel.Interval.allCases) { interval in
                Text(interval.rawValue)
                    .tag(interval)
            }
        }
        .onChange(of: tickerViewModel.selectedInterval) { interval in
            Task {
                await tickerViewModel.fetchCandles()
                tickerViewModel.animateChart()
            }
        }
        .padding(.horizontal, -11)
    }
    
    private var displayedViewPicker: some View {
        Picker("Displayed View", selection: $tickerViewModel.displayedView) {
            ForEach(TickerViewModel.DisplayedView.allCases) { view in
                Text(view.rawValue)
                    .tag(view)
            }
        }
        .pickerStyle(.segmented)
        .onChange(of: tickerViewModel.displayedView) { newValue in
            SoundManager.instance.playTab()
            Task {
                await tickerViewModel.refreshDisplayedView()
            }
        }
    }
    
    //helper function, because timer doesn't support async functions
    //don't know if it's neccessary, api doen't change that frequently
    private func refreshDisplayedView(timer: Timer) {
        Task {
            await tickerViewModel.refreshDisplayedView()
        }
    }
    
    //on drag
    private func onDragGesture(value: DragGesture.Value) {
        if value.translation.width < 0, let symbolId = tickerViewModel.symbol?.symbol {
            let symbol = marketsViewModel.getNextSymbol(symbolId: symbolId)
            if let symbol {
                SoundManager.instance.playTransitionRight()
                navigationPath.append(symbol)
            }
        }

        if value.translation.width > 0 {
            SoundManager.instance.playTransitionLeft()
            navigationPath.removeLast()
        }
    }
}

struct TickerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TickerDetailView(symbol: "BTC / USDT", navigationPath: .constant([]), marketsViewModel: .init())
    }
}
