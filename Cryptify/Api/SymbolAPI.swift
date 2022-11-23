//
//  SymbolsAPI.swift
//  Cryptify
//
//  Created by Jan Babák on 22.11.2022.
//

import Foundation

//api endpoint documentation https://docs.poloniex.com/#public-endpoints-market-data-prices

class SymbolAPI: API<Symbol> {
    
    @MainActor
    func fetchAllSymbols() async -> [Symbol] {
        return await fetchAll(path: "/price")
    }
    
    @MainActor
    func fetchSymbol(symbolId: String) async -> Symbol? {
        return await fetch(path: "/\(symbolId)/price")
    }
}
