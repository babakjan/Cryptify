//
//  LineChart.swift
//  Cryptify
//
//  Created by Jan Babák on 23.11.2022.
//

import SwiftUI
import Charts

struct LineChartView: View {
    @State var candles: [Candle]
    
    var body: some View {
        Chart(candles.indices, id: \.self) { index in
            LineMark(
                x: .value("Mont", index),
                y: .value("Price", candles[index].openCloseAvg)
            )
            .lineStyle(.init(lineWidth: 4, lineCap: .round))
            .interpolationMethod(.cardinal)
        }
    }
}

struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        LineChartView(candles: [])
    }
}
