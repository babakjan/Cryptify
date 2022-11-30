//
//  ContentView.swift
//  Cryptify
//
//  Created by Jan Babák on 19.11.2022.
//

import SwiftUI

struct ContentView: View {
    @State var navigationPath: [Symbol] = []
    
    var body: some View {
        NavigationView {
            NavigationStack(path: $navigationPath) {
                MarketsView(navigationPath: $navigationPath)
                    .foregroundColor(.theme.text)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
