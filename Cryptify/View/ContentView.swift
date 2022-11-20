//
//  ContentView.swift
//  Cryptify
//
//  Created by Jan Babák on 19.11.2022.
//

import SwiftUI

struct ContentView: View {
    let styles: Styles = Styles()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            MarketsView()
        }
        .foregroundColor(colorScheme == .light ? styles.colors["black"] : .white)
        .padding(.vertical, 8)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
