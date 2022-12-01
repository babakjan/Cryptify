//
//  Constants.swift
//  Cryptify
//
//  Created by Jan Babák on 30.11.2022.
//

import Foundation

enum Theme: String, CaseIterable, Identifiable {
    case light
    case dark
    case system
    
    var id: String {
        self.rawValue
    }
}
