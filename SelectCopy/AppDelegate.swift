//
//  AppDelegate.swift
//  SelectCopy
//
//  Created by Kamaal M Farah on 03/08/2023.
//

import Cocoa

// - MARK: AppDelegate

final class AppDelegate: NSObject {
    private var statusItem: NSStatusItem!
    private let textHighlightObserver = TextHighlightObserver()
    private let userData = UserData()
}

// - MARK: NSApplicationDelegate

extension AppDelegate: NSApplicationDelegate {
    func applicationDidFinishLaunching(_: Notification) {
        setupStatusItem()
        closeAllWindowsExceptForStatusBarWindow()
        textHighlightObserver.start()
    }
}

// - MARK: Private

extension AppDelegate {
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button!.image = NSImage(
            systemSymbolName: "highlighter",
            accessibilityDescription: NSLocalizedString("Text hightlighter icon", comment: "")
        )
        let menu = AppMenu.build(userData: userData)
        statusItem.menu = menu
    }

    private func closeAllWindowsExceptForStatusBarWindow() {
        let statusItemWindow = statusItem.button!.window
        for window in NSApplication.shared.windows where window != statusItemWindow {
            window.close()
        }
    }
}
