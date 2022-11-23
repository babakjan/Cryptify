//
//  LineChart.swift
//  Cryptify
//
//  Created by Jan Babák on 23.11.2022.
//

import SwiftUI
import Charts

struct LineChart: View {
    @State var candles: [Candle]
    @State var color: Color
    
    var body: some View {
        GroupBox {
            VStack(alignment: .trailing) {
                ScrollView (.horizontal) {
                    ScrollViewReader { scroller in
                        Chart(candles.indices, id: \.self) { index in
                            LineMark(
                                x: .value("Mont", index),
                                y: .value("Price", candles[index].openCloseAvg)
                            )
                            .foregroundStyle(color)
                        }
                        .padding(5)
                        .frame(width: CGFloat(candles.count) * 7, height: 250)
                        .id(1) //scroller
                        .onAppear {
                            //scroll chart to the end of graph, because there is y axis
                            scroller.scrollTo(1, anchor: .trailing)
                        }
                    }
                }
            }
        }
    }
}

struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        LineChart(candles: [], color: .green)
    }
}
