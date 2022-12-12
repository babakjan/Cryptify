//
//  API.swift
//  Cryptify
//
//  Created by Jan Babák on 19.11.2022.
//

import Foundation

class API<T: Decodable> {
    let serverUrl = "https://api.poloniex.com/markets"
    
    //fetch collection - return array of T
    func fetchAll(path: String, parameters: [Parameter: String] = [:]) async throws -> [T] {
        let url = createUrl(path: path, parameters: parameters)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 16
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                throw APIError.clientError
            }
            if response.isClientError() {
                throw APIError.clientError
            } else if response.isServerError() {
                throw APIError.serverError
            }
            
            return try JSONDecoder().decode([T].self, from: data)
        } catch {
            print("[FETCH ALL ERROR]", error.localizedDescription)
            throw APIError.clientError
        }
    }
    
    //fetch single entity - return instance of T?
    func fetch(path: String, parameters: [Parameter: String] = [:]) async throws -> T? {
        let url = createUrl(path: path, parameters: parameters)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 16
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                throw APIError.clientError
            }
            if response.isClientError() {
                throw APIError.clientError
            } else if response.isServerError() {
                throw APIError.serverError
            }
            
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("[FETCH ERROR]", error.localizedDescription)
            throw APIError.clientError
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
    
    //errors thrown by API
    enum APIError: Error, LocalizedError {
        case clientError
        case serverError
        
        var errorDescription: String? {
            switch self {
            case .serverError:
                return NSLocalizedString("The server is currently unavailable. Please wait, we are working on that.", comment: "")
            case .clientError:
                return NSLocalizedString("You may have lost your connection or something have broken on your device.", comment: "")
            }
        }
    }
}
