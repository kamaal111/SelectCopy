//
//  ContentView.swift
//  Playground
//
//  Created by Kamaal Farah on 8/6/23.
//

import SwiftUI
import KamaalUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            KScrollableForm {
                KSection(header: "Personalization") {
                    PlaygroundNavigationButton(title: "App logo creator", destination: .appLogoCreator)
                }
            }
            .navigationDestination(for: Screens.self) { screen in
                switch screen {
                case .appLogoCreator: AppLogoCreatorScreen()
                }
            }
        }
        .padding(.all, 16)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
