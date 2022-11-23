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
        print(url)
        var request = URLRequest(url: URL(string: url)!)
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
    func fetch(path: String, parameters: [String: String] = [:]) async -> T? {
        var request = URLRequest(url: URL(string: createUrl(path: path, parameters: parameters))!)
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
    
    //create url from server url, path and parameters
    func createUrl(path: String, parameters: [String: String] = [:]) -> String {
        var url = path
        var connector = "?"
        for (label, value) in parameters {
            url = url + connector + label + "=" + value
            connector = "&"
        }
        return serverUrl + url
    }
}
