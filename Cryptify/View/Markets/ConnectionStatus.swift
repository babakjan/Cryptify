//
//  ConnectionStatus.swift
//  Cryptify
//
//  Created by Jan Babák on 20.11.2022.
//

import SwiftUI

struct ConnectionStatus: View {
    
    var body: some View {
        HStack {
            //TODO add logic
            Text("Status: online")
            
            Image(systemName: "checkmark.icloud")
        }
        .foregroundColor(.theme.secondaryText)
    }
}

struct ConnectionStatus_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionStatus()
    }
}
