//
//  LoadingView.swift
//  Cryptify
//
//  Created by Jan Babák on 12.12.2022.
//

import SwiftUI

//custom loading, source https://www.youtube.com/watch?v=wA93Dgp-G-4
struct LoadingView: View {
    var dimension: CGFloat = 36
    
    @State var animate = false
    
    var body: some View {
        VStack(alignment: .center) {
            Circle()
                .trim(from: 0, to: 0.8)
                .stroke(
                    AngularGradient(
                        gradient: .init(colors: [.theme.accent, .theme.accent.opacity(0)]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 7, lineCap: .round)
                )
                .frame(width: dimension, height: dimension)
                .rotationEffect(Angle(degrees: animate ? 360 : 0))
                .animation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false), value: animate)
                .padding()
        }
        .frame(maxWidth: .infinity)
        .onAppear() {
            animate.toggle()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
