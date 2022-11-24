//
//  Color.swift
//  Cryptify
//
//  Created by Jan Babák on 23.11.2022.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let text = Color("Text")
    let secondaryText = Color("SecondaryText")
    let lightGray = Color("LightGray")
    let green = Color("Green")
    let red = Color("Red")
}
