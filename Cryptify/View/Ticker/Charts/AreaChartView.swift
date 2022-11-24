//
//  AreaChart.swift
//  Cryptify
//
//  Created by Jan Babák on 24.11.2022.
//

import SwiftUI
import Charts

struct AreaChartView: View {
    @State var candles: [Candle]
    
    var body: some View {
        Chart(candles.indices, id: \.self) { index in
            AreaMark(
                x: .value("Mont", index),
                y: .value("Price", candles[index].openCloseAvg)
            )
            .interpolationMethod(.cardinal)
        }
    }
}

struct AreaChart_Previews: PreviewProvider {
    static var previews: some View {
        AreaChartView(candles: [])
    }
}
