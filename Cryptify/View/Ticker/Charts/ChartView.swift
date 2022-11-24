//
//  ChartView.swift
//  Cryptify
//
//  Created by Jan Babák on 24.11.2022.
//

import SwiftUI

struct ChartView: View {
    @StateObject var viewModel: TickerViewModel
    
    var body: some View {
        GroupBox {
            VStack(alignment: .trailing) {
                ScrollView (.horizontal) {
                    ScrollViewReader { scroller in
                        chart
                        .frame(width: CGFloat(viewModel.candles.count) * 6, height: 250)
                        .padding(4)
                        .id(1) //for scroller
                        .onAppear {
                            //scroll chart to the end of graph, because there is y axis
                            scroller.scrollTo(1, anchor: .trailing)
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
            } else {
                if let symbol = viewModel.symbol {
                    Group {
                        if viewModel.selectedChart == TickerViewModel.ChartType.area {
                            AreaChartView(candles: viewModel.candles)
                        } else {
                            LineChartView(candles: viewModel.candles)
                        }
                    }
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                (symbol.dailyChange < 0 ? Color.theme.red : Color.theme.green),
                                (symbol.dailyChange < 0 ? Color.theme.red : Color.theme.green).opacity(0.2)
                            ],
                            startPoint: .center,
                            endPoint: .bottom
                        )
                    )
                }
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(viewModel: .init(symbolId: "BTC_USDT"))
    }
}
