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
    func fetchAll(path: String, parameters: [String: String] = [:]) async -> [T] {
        let url = createUrl(path: path, parameters: parameters)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 16
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return try JSONDecoder().decode([T].self, from: data)
        } catch {
            print("[FETCH ALL ERROR]", error)
            return []
        }
    }
    
    @MainActor
    func fetch(path: String, parameters: [String: String] = [:]) async -> T? {
        let url = createUrl(path: path, parameters: parameters)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 16
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("[FETCH ERROR]", error)
            return nil
        }
    }
    
    //create url from server url, path and parameters
    func createUrl(path: String, parameters: [String: String] = [:]) -> URL {
        var url = path
        var connector = "?"
        for (label, value) in parameters {
            url = url + connector + label + "=" + value
            connector = "&"
        }
        return URL(string: serverUrl + url)!
    }
}
