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
        Chart(candles.indices, id: \.self) { index in
            RectangleMark(
                x: .value("Month", index),
                yStart: .value("Low price", candles[index].low),
                yEnd: .value("High price", candles[index].high),
                width: 2
            )
            .foregroundStyle(candles[index].color)
            .opacity(0.4)
            
            RectangleMark(
                x: .value("Month", index),
                yStart: .value("Open price", candles[index].open),
                yEnd: .value("Close price", candles[index].close),
                width: 6
            )
            .foregroundStyle(candles[index].color)
        }
    }
}

struct CandleChart_Previews: PreviewProvider {
    static var previews: some View {
        CandleChartView(candles: [])
    }
}
