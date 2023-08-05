//
//  AppMenu.swift
//  SelectCopy
//
//  Created by Kamaal M Farah on 05/08/2023.
//

import SwiftUI

final class AppMenu: NSMenu {
    var userData: UserData!

    static func build(userData: UserData) -> NSMenu {
        let menu = AppMenu(userData: userData)
        menu.addItem(
            withTitle: NSLocalizedString("Settings", comment: ""),
            action: #selector(openPreferences),
            keyEquivalent: ","
        )
        menu.addItem(
            withTitle: NSLocalizedString("Quit SelectCopy", comment: ""),
            action: #selector(quitApp),
            keyEquivalent: "q"
        )
        return menu
    }

    private convenience init(userData: UserData) {
        self.init()
        self.userData = userData
    }

    private init() {
        super.init(title: "")
    }

    @available(*, unavailable)
    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func quitApp(_: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }

    @objc
    private func openPreferences(_: NSMenuItem) {
        let view = AppSettingsScreen().environmentObject(userData)
        let controller = NSHostingController(rootView: view)
        let window = NSWindow(contentViewController: controller)
        window.title = NSLocalizedString("Settings", comment: "")
        window.makeKeyAndOrderFront(self)
        let windowController = NSWindowController(window: window)
        windowController.showWindow(self)
    }
}
