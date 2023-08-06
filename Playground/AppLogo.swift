//
//  AppLogo.swift
//  Playground
//
//  Created by Kamaal M Farah on 06/08/2023.
//

import SwiftUI
import KamaalUI
import KamaalExtensions

struct AppLogo: View {
    let size: CGFloat
    let backgroundColor: Color
    let primaryColor: Color
    let curvedCornersSize: CGFloat
    let hasABackrgound: Bool

    var body: some View {
        ZStack {
            if hasABackrgound {
                gradientBackgroundColor
            }
            Image(systemName: "clipboard")
                .kSize(.init(width: size / 2, height: size / 1.7))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(primaryColor)
            Image(systemName: "highlighter")
                .kSize(.squared(size / 4))
                .rotation3DEffect(.degrees(180), axis: (x: 0.0, y: 1.0, z: 0.0))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(primaryColor)
                .padding(.top, size / 8)
        }
        .frame(width: size, height: size)
        .cornerRadius(curvedCornersSize)
    }

    private var gradientBackgroundColor: some View {
        LinearGradient(colors: [backgroundColor, backgroundColor, primaryColor], startPoint: .top, endPoint: .bottom)
    }
}

#Preview {
    AppLogo(size: 150, backgroundColor: .black, primaryColor: .accentColor, curvedCornersSize: 16, hasABackrgound: true)
        .padding(.all)
        .previewLayout(.sizeThatFits)
}
