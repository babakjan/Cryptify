//
//  CandlesAPI.swift
//  Cryptify
//
//  Created by Jan Babák on 22.11.2022.
//

import Foundation

//api endpoint documentation https://docs.poloniex.com/#public-endpoints-market-data-candles

class CandleAPI: API<[Either<UInt64, String>]> {
    
    @MainActor
    func fetchAllCandles(symbolId: String, interval: Interval = .MONTH_1, limit: String = "500") async -> [Candle] {
        let eitherArrays = await fetchAll(
            path: "/\(symbolId)/candles",
            parameters: [
                "interval": interval.description,
                "limit": limit
            ]
        )
        var candles: [Candle] = []
        do {
            for (idx, eitherArray) in eitherArrays.enumerated() {
                try candles.append(Candle.fromEitherArray(eitherArray, id: idx))
            }
            print("candles count ", candles.count)
            return candles
        } catch {
            print("[ERROR]", error)
            return []
        }
    }
    
    //api parameter
    enum Interval: CustomStringConvertible {
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
        
        var description: String {
            switch self {
            case .MINUTE_1: return "MINUTE_1"
            case .MINUTE_5: return "MINUTE_5"
            case .MINUTE_10: return "MINUTE_10"
            case .MINUTE_15: return "MINUTE_15"
            case .MINUTE_30: return "MINUTE_30"
            case .HOUR_1: return "HOUR_1"
            case .HOUR_2: return "HOUR_2"
            case .HOUR_4: return "HOUR_4"
            case .HOUR_6: return "HOUR_6"
            case .HOUR_12: return "HOUR_12"
            case .DAY_1: return "DAY_1"
            case .DAY_3: return "DAY_3"
            case .WEEK_1: return "WEEK_1"
            case .MONTH_1: return "MONTH_1"
            }
        }
    }
}
