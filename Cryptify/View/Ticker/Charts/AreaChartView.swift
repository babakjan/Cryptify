//
//  AreaChart.swift
//  Cryptify
//
//  Created by Jan Babák on 24.11.2022.
//

import SwiftUI
import Charts

struct AreaChartView: View {
    @StateObject var viewModel: TickerViewModel
    
    var body: some View {
        Chart(viewModel.candles) { candle in
            AreaMark(
                x: .value("Date", candle.startTime),
                y: .value("Price", candle.animate ? candle.openCloseAvg : 0)
            )
            .interpolationMethod(.cardinal)
            .foregroundStyle(viewModel.graphColor)
        }
        .chartYScale(domain: 0...viewModel.candles.max(by: {
            (a, b)-> Bool in return a.openCloseAvg < b.openCloseAvg
            
        })!.openCloseAvg * 1.05)
        .onAppear() {
            viewModel.animateChart()
        }
    }
}

struct AreaChart_Previews: PreviewProvider {
    static var previews: some View {
        AreaChartView(viewModel: .init(symbolId: "BTC_UDST"))
    }
}
