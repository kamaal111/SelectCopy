//
//  SettingsScreen.swift
//  SelectCopy
//
//  Created by Kamaal M Farah on 05/08/2023.
//

import SwiftUI
import KamaalSettings

struct AppSettingsScreen: View {
    @EnvironmentObject private var userData: UserData

    var body: some View {
        SettingsScreen(configuration: userData.settingsConfiguration)
            .frame(width: 300, height: 160)
    }
}
