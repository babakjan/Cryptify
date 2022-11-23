//
//  CandleChart.swift
//  Cryptify
//
//  Created by Jan Babák on 23.11.2022.
//

import SwiftUI
import Charts

struct CandleChart: View {
    @State var candles: [Candle]
    
    var body: some View {
        GroupBox {
            VStack(alignment: .trailing) {
                ScrollView (.horizontal) {
                    ScrollViewReader { scroller in
                        Chart(candles.indices, id: \.self) { index in
                            RectangleMark(
                                x: .value("Mont", index),
                                yStart: .value("Low price", candles[index].low),
                                yEnd: .value("High price", candles[index].high),
                                width: 2
                            )
                            .foregroundStyle(candles[index].color)
                            .opacity(0.4)
                            
                            RectangleMark(
                                x: .value("Mont", index),
                                yStart: .value("Open price", candles[index].open),
                                yEnd: .value("Close price", candles[index].close),
                                width: 6
                            )
                            .foregroundStyle(candles[index].color)
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

struct CandleChart_Previews: PreviewProvider {
    static var previews: some View {
        CandleChart(candles: [])
    }
}
