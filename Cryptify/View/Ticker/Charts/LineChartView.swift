//
//  LineChart.swift
//  Cryptify
//
//  Created by Jan Babák on 23.11.2022.
//

import SwiftUI
import Charts

struct LineChartView: View {
    @StateObject var viewModel: TickerViewModel
    
    var body: some View {
        Chart(viewModel.candles) { candle in
            LineMark(
                x: .value("Date", candle.startTime),
                y: .value("Price", candle.animate ? candle.close : 0)
            )
            .lineStyle(.init(lineWidth: 3, lineCap: .round))
            .interpolationMethod(.cardinal)
            .foregroundStyle(viewModel.graphColor)
        }
    }
}

struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        LineChartView(viewModel: .init(symbolId: "BTC_USDT"))
    }
}




