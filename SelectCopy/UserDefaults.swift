//
//  UserDefaults.swift
//  SelectCopy
//
//  Created by Kamaal M Farah on 06/08/2023.
//

import Foundation
import KamaalUtils

extension UserDefaults {
    @UserDefaultsValue(key: "copying_on_highlight_is_disabled", container: .standard)
    static var copyingOnHighlightIsDisabled: Bool?
}
