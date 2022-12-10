//
//  ChartView.swift
//  Cryptify
//
//  Created by Jan Babák on 24.11.2022.
//

import SwiftUI

struct ChartView: View {
    @StateObject var viewModel: TickerViewModel
    private let scrennWidth = UIScreen.main.bounds.size.width - 70
    
    private var chartWidth: CGFloat {
        let scale = CGFloat(viewModel.candles.count) * 12
        return viewModel.selectedChart != TickerViewModel.ChartType.candles || scale < scrennWidth ? scrennWidth : scale
    }
    
    var body: some View {
        GroupBox {
            if viewModel.candles.isEmpty {
                ProgressView().progressViewStyle(.circular)
            } else {
                VStack(alignment: .trailing) {
                    ScrollView (.horizontal) {
                        ScrollViewReader { scroller in
                            chart
                                .chartYScale(domain: viewModel.candlesAdjustedMinClose!...viewModel.candlesAdjustedMaxClose!)
                                .frame(width: chartWidth, height: 250)
                                .padding(4)
                                .id(1) //for scroller
                                .onAppear {
                                    //scroll chart to the end of graph, because there is current price
                                    scroller.scrollTo(1, anchor: .trailing)
                                }
                        }
                    }
                }
            }
        }
    }
    
    private var chart: some View {
        Group {
            if viewModel.selectedChart == TickerViewModel.ChartType.candles {
                CandleChartView(viewModel: viewModel)
            } else if viewModel.selectedChart == TickerViewModel.ChartType.area {
                AreaChartView(viewModel: viewModel)
            } else {
                LineChartView(viewModel: viewModel)
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(viewModel: .init(symbolId: "BTC_USDT"))
    }
}
