//
//  Candle.swift
//  Cryptify
//
//  Created by Jan Babák on 22.11.2022.
//

import Foundation
import SwiftUI

//Candle in candle chart
struct Candle: Hashable, Identifiable {
    var id: Int
    var low: Double //lowest price over the interval
    var high: Double //highest price over the interval
    var open: Double //price at the start time
    var close: Double //price at the end time
    var amount: Double //quote units traded over the interval
    var quantity: Double //base units traded over the interval
    var tradeCount: UInt64 //count of trades
    var ts: UInt64 //time the record was pushed
    var weightedAverage: Double //weighted average over the interval
    var interval: String //the selected interval
    var startTime: Date //start time of interval
    var endTime: Date //end time of interval
    var animate = false //for chart animations
    
    var color: Color { //color of candle
        open < close ? Color.theme.green : Color.theme.red
    }
    
    var openCloseAvg: Double {
        (open + close) / 2
    }
}

extension Candle {
    struct BadInputError: Error {}
    
    //create Candle object from array of Either (some elements are string and some number)
    static func fromEitherArray(_ array: [Either<UInt64, String>], id: Int) throws -> Candle {
        guard array.count == 14 else { throw BadInputError() }
        
        return Candle(
            id: id,
            low: Double(array[0].get().1!)!,
            high: Double(array[1].get().1!)!,
            open: Double(array[2].get().1!)!,
            close: Double(array[3].get().1!)!,
            amount: Double(array[4].get().1!)!,
            quantity: Double(array[5].get().1!)!,
            tradeCount: array[8].get().0!,
            ts: array[9].get().0!,
            weightedAverage: Double(array[10].get().1!)!,
            interval: array[11].get().1!,
            startTime: Date(timeIntervalSince1970: TimeInterval(array[12].get().0!) / 1000), //divide by 1000, because api returns unix time in ms
            endTime: Date(timeIntervalSince1970: TimeInterval(array[13].get().0!) / 1000)
        )
    }
}
