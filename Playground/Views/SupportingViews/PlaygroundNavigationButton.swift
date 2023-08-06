//
//  PlaygroundNavigationButton.swift
//  Playground
//
//  Created by Kamaal M Farah on 06/08/2023.
//

import SwiftUI
import KamaalUI

struct PlaygroundNavigationButton: View {
    let title: String
    let destination: Screens

    init(title: String, destination: Screens) {
        self.title = title
        self.destination = destination
    }

    var body: some View {
        WideNavigationLink(destination: destination) {
            HStack {
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .ktakeWidthEagerly()
        }
    }
}

#Preview {
    PlaygroundNavigationButton(title: "Logo screen", destination: .appLogoCreator)
}
