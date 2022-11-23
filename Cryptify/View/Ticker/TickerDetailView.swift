//
//  TickerDetailView.swift
//  Cryptify
//
//  Created by Jan Babák on 21.11.2022.
//

import SwiftUI

struct TickerDetailView: View {
    @Binding var navigationPath: NavigationPath
    @StateObject var viewModel: TickerViewModel
    let styles: Styles
    
    //TODO how to initialiye navigation path - used before initialization
    init(symbol: String, navigationPath: Binding<NavigationPath>) {
        self._viewModel = StateObject(wrappedValue: TickerViewModel(symbolId: symbol))
        self._navigationPath = navigationPath
        styles = .init()
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if let ticker = viewModel.ticker, let symbol = viewModel.symbol {
                    VStack(alignment: .leading) {
                        PriceAndDailyChangeView(symbol: symbol, styles: styles)
                        
                        chartTypePicker
                            .padding(.bottom, 8)
                        
                        if viewModel.candles.count != 0 {
                            
                            if viewModel.selectedChart == TickerViewModel.ChartType.line {
                                LineOrAreaChart(
                                    candles: viewModel.candles,
                                    color: symbol.dailyChange < 0 ? styles.colors["red"]! : styles.colors["green"]!,
                                    type: TickerViewModel.ChartType.line
                                )
                            } else if viewModel.selectedChart == TickerViewModel.ChartType.area {
                                LineOrAreaChart(
                                    candles: viewModel.candles,
                                    color: symbol.dailyChange < 0 ? styles.colors["red"]! : styles.colors["green"]!,
                                    type: TickerViewModel.ChartType.area
                                )
                            } else {
                                CandleChart(candles: viewModel.candles)
                            }
                            
                            Spacer()
                        }//TODO progress view when loading
                        
                        
                        DetailsView(ticker: ticker, styles: styles)
                    }
                    .navigationTitle(ticker.displayName)
                } else {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
            .task {
                await viewModel.fetchTicker()
                await viewModel.fetchSymbol()
                await viewModel.fetchCandles()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TickerHeaderView {
                        navigationPath.removeLast()
                    }
                }
            }
        }
    }

    var chartTypePicker: some View {
        Picker("Chart type", selection: $viewModel.selectedChart) {
            ForEach(TickerViewModel.ChartType.allCases) { chartType in
                Text(chartType.rawValue)
                    .tag(chartType)
            }
        }
        .pickerStyle(.segmented)
    }
}

//struct TickerDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        TickerDetailView(
//            navigationPath: .constant(NavigationPath()),
//            symbol: "BTC / USDT",
//            viewModel: TickerViewModel(symbol: "TRX_USDC"),
//            styles: .init()
//        )
//    }
//}
