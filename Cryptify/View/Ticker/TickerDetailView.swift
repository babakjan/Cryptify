//
//  TickerDetailView.swift
//  Cryptify
//
//  Created by Jan Babák on 21.11.2022.
//

import SwiftUI

struct TickerDetailView: View {
    @Binding var navigationPath: NavigationPath
    var symbol: String
    @StateObject var viewModel: TickerViewModel
    let styles: Styles
    
    //TODO how to initialiye navigation path - used before initialization
//    init(symbol: String, navigationPath: NavigationPath) {
//        self.symbol = symbol
//        self._viewModel = StateObject(wrappedValue: TickerViewModel(symbol: symbol))
//        self.navigationPath = navigationPath
//    }
    
    var body: some View {
        ScrollView {
            VStack {
                if let ticker = viewModel.ticker, let symbol = viewModel.symbol {
                    VStack(alignment: .leading) {
                        PriceAndDailyChangeView(symbol: symbol, styles: styles)
                        
                        if viewModel.candles.count != 0 {
                            CandleChart(candles: viewModel.candles)
                            
                            LineChart(
                                candles: viewModel.candles,
                                color: symbol.dailyChange < 0 ? styles.colors["red"]! : styles.colors["green"]!
                            )
                        }//TODO progress view when loading
                        
                        Spacer()
                        
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
}

struct TickerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TickerDetailView(
            navigationPath: .constant(NavigationPath()),
            symbol: "BTC / USDT",
            viewModel: TickerViewModel(symbol: "TRX_USDC"),
            styles: .init()
        )
    }
}
