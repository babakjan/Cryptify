//
//  ResourceState.swift
//  Cryptify
//
//  Created by Jan Babák on 12.12.2022.
//

import Foundation

//state of requested resource
enum ResourceState: Equatable {
    case loading
    case ok
    case error(messageLocalizedKey: String = "")
    
    //custom comparator, besause I want .error equals .error regardless of the message value
    static func ==(lhs: ResourceState, rhs: ResourceState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.ok, .ok):
            return true
        case (.error, .error):
            return true
        default:
            return false
        }
    }
}
