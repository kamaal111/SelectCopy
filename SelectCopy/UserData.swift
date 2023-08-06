//
//  UserData.swift
//  SelectCopy
//
//  Created by Kamaal M Farah on 05/08/2023.
//

import SwiftUI
import KamaalSettings

final class UserData: ObservableObject {
    @Published private var appColor = AppColor(
        id: UUID(uuidString: "90b000f4-46c2-4c89-a8ef-9c5cb0701e46")!,
        name: NSLocalizedString("Default Color", comment: ""),
        color: Color("AccentColor")
    )

    private let showLogs = true

    var settingsConfiguration: SettingsConfiguration {
        .init(color: colorConfiguration, showLogs: showLogs)
    }

    private var colorConfiguration: SettingsConfiguration.ColorsConfiguration {
        .init(colors: [appColor], currentColor: appColor)
    }
}
