//
//  Symbol.swift
//  Cryptify
//
//  Created by Jan Babák on 19.11.2022.
//

import Foundation

struct Symbol: Decodable {
    var symbol: String //symbol name
    var price: String //current price
    var time: UInt64 //time the record was created
    var dailyChange: String //dayli change in decimal
    var ts: UInt64 //time the record was published
}
