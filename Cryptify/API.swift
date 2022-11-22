//
//  API.swift
//  Cryptify
//
//  Created by Jan Babák on 19.11.2022.
//

import Foundation

class API<T: Decodable> {
    let serverUrl = "https://api.poloniex.com/markets"
    
    @MainActor
    func fetchAll(url: String) async -> [T] {
        var request = URLRequest(url: URL(string: serverUrl + url)!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return try JSONDecoder().decode([T].self, from: data)
        } catch {
            print("[ERROR]", error)
            return []
        }
    }
    
    @MainActor
    func fetch(url: String) async -> T? {
        var request = URLRequest(url: URL(string: serverUrl + url)!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("[ERROR]", error)
            return nil
        }
    }
}
