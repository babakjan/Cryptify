//
//  HTTPURLResponse.swift
//  Cryptify
//
//  Created by Jan Babák on 12.12.2022.
//

import Foundation

extension HTTPURLResponse {
    func isOK() -> Bool {
        return (200...210).contains(self.statusCode) //there are only 200...206 status codes, but in case newone will be added
    }
    
    func isServerError() -> Bool {
        return (500...520).contains(self.statusCode) //there are only 500...511 status codes
    }
    
    func isClientError() -> Bool {
        return (400...470).contains(self.statusCode) //there are only 400...451 status codes
    }
}
