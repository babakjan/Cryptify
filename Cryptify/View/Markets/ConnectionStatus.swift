//
//  ConnectionStatus.swift
//  Cryptify
//
//  Created by Jan Babák on 20.11.2022.
//

import SwiftUI

struct ConnectionStatus: View {
    let styles: Styles
    
    var body: some View {
        HStack {
            //TODO add logic
            Text("Status: online")
                .foregroundColor(styles.colors["black50"])
            
            Image(systemName: "checkmark.icloud")
                .foregroundColor(styles.colors["black75"])
        }
    }
}

struct ConnectionStatus_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionStatus(styles: .init())
    }
}
