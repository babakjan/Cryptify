//
//  CandleChart.swift
//  Cryptify
//
//  Created by Jan Babák on 23.11.2022.
//

import SwiftUI
import Charts

struct CandleChartView: View {
    @State var candles: [Candle]

    var body: some View {
        Chart(candles) { candle in
            //high low
            RectangleMark(
                x: .value("Date", candle.startTime),
                yStart: .value("Low price", candle.low),
                yEnd: .value("High price", candle.high),
                width: 2
            )
            .foregroundStyle(candle.color)
            .opacity(0.4)
            
            //open close
            RectangleMark(
                x: .value("Price", candle.startTime),
                yStart: .value("Open price", candle.open),
                yEnd: .value("Close price", candle.close),
                width: 8
            )
            .foregroundStyle(candle.color)
        }
        .chartYScale(domain: 0...candles.max(by: { $0.close < $1.close})!.close * 1.05)
    }
}

struct CandleChart_Previews: PreviewProvider {
    static var previews: some View {
        CandleChartView(candles: [])
    }
}
