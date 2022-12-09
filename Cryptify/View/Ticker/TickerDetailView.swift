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
            VStack {
                if let ticker = tickerViewModel.ticker, let symbol = tickerViewModel.symbol {
                    VStack(alignment: .leading) {
                        
                        PriceAndDailyChangeView(symbol: symbol)
                            .padding(.top, 8)
                        
                        HStack {
                            chartTypePicker
                            //                            .padding(.bottom, 8)
                            intervalPicker
                        }
                        
                        if !tickerViewModel.candles.isEmpty {
                            ChartView(viewModel: tickerViewModel)
                        }//TODO progress view when loading
                        
                        
                        
                        DetailsView(ticker: ticker)
                            .padding(.top, 16)
                        
                        OrderBookView(tickerViewModel: tickerViewModel)
                            .padding(.top, 16)
                    }
                    .navigationTitle(ticker.displayName)
                    .gesture(
                        DragGesture(minimumDistance: 10, coordinateSpace: .local)
                            .onEnded(onDragGesture)
                    )
                    
                } else {
                    ProgressView()
                        .progressViewStyle(.circular)
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
        .task {
            await tickerViewModel.fetchData()
        }
        .refreshable {
            await tickerViewModel.fetchData()
        }
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: refreshOrderBook)
        }
        .onDisappear() {
            if let timer { timer.invalidate() }
        }
    }
    
    //helper function, because timer doesn't support async functions
    //don't know if it's neccessary, api doen't change that frequently
    private func refreshOrderBook(timer: Timer) {
        Task {
            await tickerViewModel.fetchSymbol()
        }
    }

    private var chartTypePicker: some View {
        Picker("Chart type", selection: $tickerViewModel.selectedChart) {
            ForEach(TickerViewModel.ChartType.allCases) { chartType in
                Text(chartType.rawValue)
                    .tag(chartType)
            }
        }
//        .pickerStyle(.segmented)
        .onChange(of: tickerViewModel.selectedChart) { newValue in
            SoundManager.instance.playTab()
        }
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
