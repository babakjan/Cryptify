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
            //line chart
            LineMark(
                x: .value("Date", candle.startTime),
                y: .value("Price", candle.animate ? candle.close : 0)
            )
            .lineStyle(.init(lineWidth: 4, lineCap: .round))
            .interpolationMethod(.cardinal)
            .foregroundStyle(viewModel.graphColor)
            
            //gradient area under the line chart
            AreaMark(
                x: .value("Date", candle.startTime),
                y: .value("Price", candle.animate ? candle.close : 0)
            )
            .lineStyle(.init(lineWidth: 4, lineCap: .round))
            .interpolationMethod(.cardinal)
            .foregroundStyle(Gradient(colors: [viewModel.graphColor.opacity(0.5), viewModel.graphColor.opacity(0)]))
        }
        .chartYScale(domain: 0...viewModel.candles.max(by: { $0.close < $1.close })!.close * 1.05)
        .onAppear() {
            viewModel.animateChart()
        } 
    }
}

struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        LineChartView(viewModel: .init(symbolId: "BTC_USDT"))
    }
}




