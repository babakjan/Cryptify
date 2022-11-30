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
    
    var body: some View {
        GroupBox {
            VStack(alignment: .trailing) {
                ScrollView (.horizontal) {
                    ScrollViewReader { scroller in
                        chart
                        .frame(width: CGFloat(viewModel.candles.count) * 12 < scrennWidth ? scrennWidth : CGFloat(viewModel.candles.count) * 12, height: 250)
                        .padding(4)
                        .id(1) //for scroller
                        .onAppear {
                            //scroll chart to the end of graph, because there is y axis
                            scroller.scrollTo(1, anchor: .trailing)
                            print("sika", UIScreen.main.bounds.size.width)
                        }
                    }
                }
            }
        }
    }
    
    var chart: some View {
        Group {
            if viewModel.selectedChart == TickerViewModel.ChartType.candles {
                CandleChartView(candles: viewModel.candles)
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
