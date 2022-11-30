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
                        
                        chartTypePicker
                            .padding(.bottom, 8)
                        
                        if tickerViewModel.candles.count != 0 {
                            ChartView(viewModel: tickerViewModel)
                        }//TODO progress view when loading
                        
                        DetailsView(ticker: ticker)
                    }
                    .navigationTitle(ticker.displayName)
                    .gesture(DragGesture(minimumDistance: 10, coordinateSpace: .local)
                        .onEnded({ value in
                            if value.translation.width < 0, let symbolId = tickerViewModel.symbol?.symbol {
                                let symbol = marketsViewModel.getNextSymbol(symbolId: symbolId)
                                if let symbol {
                                    navigationPath.append(symbol)
                                } else {
                                    print("end of list")
                                }
                            }

                            if value.translation.width > 0 {
                                navigationPath.removeLast()
                            }
                    }))
                    
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
    }

    var chartTypePicker: some View {
        Picker("Chart type", selection: $tickerViewModel.selectedChart) {
            ForEach(TickerViewModel.ChartType.allCases) { chartType in
                Text(chartType.rawValue)
                    .tag(chartType)
            }
        }
        .pickerStyle(.segmented)
    }
}

struct TickerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TickerDetailView(symbol: "BTC / USDT", navigationPath: .constant([]), marketsViewModel: .init())
    }
}
