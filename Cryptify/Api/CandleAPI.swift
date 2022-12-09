//
//  CandlesAPI.swift
//  Cryptify
//
//  Created by Jan Babák on 22.11.2022.
//

import Foundation

//api endpoint documentation https://docs.poloniex.com/#public-endpoints-market-data-candles

final class CandleAPI: API<[Either<UInt64, String>]> {
    
    @MainActor
    func fetchAllCandles(symbolId: String, interval: Interval = .MONTH_1, limit: String = "500") async -> [Candle] {
        let eitherArrays = await fetchAll(
            path: "/\(symbolId)/candles",
            parameters: [
                "interval": interval.rawValue,
                "limit": limit
            ]
        )
        var candles: [Candle] = []
        do {
            for (idx, eitherArray) in eitherArrays.enumerated() {
                try candles.append(Candle.fromEitherArray(eitherArray, id: idx))
            }
            return candles
        } catch {
            print("[FETCH CANDLES ERROR]", error)
            return []
        }
    }
    
    //api parameter
    enum Interval: String {
        case MINUTE_1
        case MINUTE_5
        case MINUTE_10
        case MINUTE_15
        case MINUTE_30
        case HOUR_1
        case HOUR_2
        case HOUR_4
        case HOUR_6
        case HOUR_12
        case DAY_1
        case DAY_3
        case WEEK_1
        case MONTH_1
    }
}
