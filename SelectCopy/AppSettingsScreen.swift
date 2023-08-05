//
//  SettingsScreen.swift
//  SelectCopy
//
//  Created by Kamaal M Farah on 05/08/2023.
//

import SwiftUI
import KamaalSettings

struct AppSettingsScreen: View {
    var body: some View {
        SettingsScreen(configuration: .init())
            .frame(minWidth: 300, minHeight: 300)
    }
}

#Preview {
    AppSettingsScreen()
}
