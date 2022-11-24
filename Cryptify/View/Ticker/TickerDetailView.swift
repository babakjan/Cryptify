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
    
    init(symbol: String, navigationPath: Binding<NavigationPath>) {
        self._viewModel = StateObject(wrappedValue: TickerViewModel(symbolId: symbol))
        self._navigationPath = navigationPath
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if let ticker = viewModel.ticker, let symbol = viewModel.symbol {
                    VStack(alignment: .leading) {
                        
                        PriceAndDailyChangeView(symbol: symbol)
                            .padding(.top, 8)
                        
                        chartTypePicker
                            .padding(.bottom, 8)
                        
                        if viewModel.candles.count != 0 {
                            ChartView(viewModel: viewModel)
                        }//TODO progress view when loading
                        
                        DetailsView(ticker: ticker)
                    }
                    .navigationTitle(ticker.displayName)
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
                    TickerHeaderView {
                        navigationPath.removeLast()
                    }
                }
            }
        }
        .task {
            await viewModel.fetchData()
        }
//        .refreshable {
//            await viewModel.fetchData(refresh: true) //TODO when refreshable, chart animation not working
//        }
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

struct TickerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TickerDetailView(
            symbol: "BTC / USDT",navigationPath: .constant(NavigationPath())
        )
    }
}
