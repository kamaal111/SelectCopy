//
//  AppDelegate.swift
//  SelectCopy
//
//  Created by Kamaal M Farah on 03/08/2023.
//

import SwiftUI

// - MARK: AppDelegate

final class AppDelegate: NSObject {
    private var statusItem: NSStatusItem!
}

// - MARK: NSApplicationDelegate

extension AppDelegate: NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusItem()
        closeAllWindowsExceptForStatusBarWindow()
    }
}

// - MARK: Private

extension AppDelegate {
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button!.image = NSImage(
            systemSymbolName: "highlighter",
            accessibilityDescription: NSLocalizedString("Text hightlighter icon", comment: ""))
        statusItem.button!.action = #selector(toggleStatusItem)
    }

    @objc
    private func toggleStatusItem(_ button: NSStatusBarButton) {
        print("Pressing")
    }

    private func closeAllWindowsExceptForStatusBarWindow() {
        let statusItemWindow = statusItem.button!.window
        for window in NSApplication.shared.windows where window != statusItemWindow {
            window.close()
        }
    }
}
