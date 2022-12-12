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
    func fetchAll(path: String, parameters: [Parameter: String] = [:]) async throws -> [T] {
        let url = createUrl(path: path, parameters: parameters)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 16
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return try JSONDecoder().decode([T].self, from: data)
        } catch {
            print("[FETCH ALL ERROR]", error)
            throw APIError.clientError
//            return []
        }
    }
    
    func fetch(path: String, parameters: [Parameter: String] = [:]) async throws -> T? {
        let url = createUrl(path: path, parameters: parameters)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 16
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("[FETCH ERROR]", error)
            throw APIError.clientError
//            return nil
        }
    }
    
    //create url from server url, path and parameters
    private func createUrl(path: String, parameters: [Parameter: String] = [:]) -> URL {
        let stringParameters = Dictionary(uniqueKeysWithValues: parameters.map { (key, value) in
            (key.rawValue, value)
        })
        
        var url = path
        var connector = "?"
        for (label, value) in stringParameters {
            url = url + connector + label + "=" + value
            connector = "&"
        }
        return URL(string: serverUrl + url)!
    }
    
    //available parameters for Poloniex API
    enum Parameter: String {
        case limit
        case interval
        case startTime
        case endTime
    }
    
    enum APIError: Error {
        case clientError
    }
}
