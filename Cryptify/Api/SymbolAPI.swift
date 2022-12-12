//
//  SymbolsAPI.swift
//  Cryptify
//
//  Created by Jan Babák on 22.11.2022.
//

import Foundation

//api endpoint documentation https://docs.poloniex.com/#public-endpoints-market-data-prices

final class SymbolAPI: API<Symbol> {
    
    func fetchAllSymbols() async throws -> [Symbol] {
        return try await fetchAll(path: "/price")
    }
    
    func fetchSymbol(symbolId: String) async throws -> Symbol? {
        return try await fetch(path: "/\(symbolId)/price")
    }
}
