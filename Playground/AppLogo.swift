//
//  AppLogo.swift
//  Playground
//
//  Created by Kamaal M Farah on 06/08/2023.
//

import SwiftUI

struct AppLogo: View {
    let size: CGFloat
    let backgroundColor: Color
    let primaryColor: Color
    let curvedCornersSize: CGFloat

    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    AppLogo(size: 150, backgroundColor: .black, primaryColor: .accentColor, curvedCornersSize: 16)
        .padding(.all)
        .previewLayout(.sizeThatFits)
}
