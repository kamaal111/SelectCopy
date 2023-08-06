//
//  AppDelegate.swift
//  SelectCopy
//
//  Created by Kamaal M Farah on 03/08/2023.
//

import SwiftUI
import KamaalLogger

// - MARK: AppDelegate

final class AppDelegate: NSObject {
    private var statusItem: NSStatusItem!
    private let textHighlightObserver = TextHighlightObserver()
    private let userData = UserData()
    private let logger = KamaalLogger(from: AppDelegate.self, failOnError: true)

    private lazy var canCopyTextMenuItem = NSMenuItem(
        title: toggleCopyMenuItemText,
        action: #selector(toggleCopy),
        keyEquivalent: ""
    )

    private lazy var menu: NSMenu = {
        let menu = NSMenu()
        menu.addItem(canCopyTextMenuItem)
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
        menu.delegate = self
        return menu
    }()
}

// - MARK: NSApplicationDelegate

extension AppDelegate: NSApplicationDelegate {
    func applicationDidFinishLaunching(_: Notification) {
        setupStatusItem()
        closeAllWindowsExceptForStatusBarWindow()
        if copyOnHighlightIsEnabled {
            logger.info("Starting text highlight observer from the start")
            textHighlightObserver.start()
        }
    }
}

extension AppDelegate: NSMenuDelegate {
    func menuWillOpen(_: NSMenu) {
        canCopyTextMenuItem.title = toggleCopyMenuItemText
    }
}

// - MARK: Private

extension AppDelegate {
    private var toggleCopyMenuItemText: String {
        if copyOnHighlightIsEnabled {
            return NSLocalizedString("Disable", comment: "")
        }
        return NSLocalizedString("Enable", comment: "")
    }

    private var copyOnHighlightIsEnabled: Bool {
        AXUIElement.isTrustedToUseAccessibilty && !(UserDefaults.copyingOnHighlightIsDisabled ?? false)
    }

    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button!.image = NSImage(
            systemSymbolName: "highlighter",
            accessibilityDescription: NSLocalizedString("Text hightlighter icon", comment: "")
        )
        statusItem.menu = menu
    }

    private func closeAllWindowsExceptForStatusBarWindow() {
        let statusItemWindow = statusItem.button!.window
        for window in NSApplication.shared.windows where window != statusItemWindow {
            window.close()
        }
    }

    @objc
    private func toggleCopy(_: NSMenuItem) {
        if !copyOnHighlightIsEnabled {
            logger.info("Enabling copying highlighted text")
            UserDefaults.copyingOnHighlightIsDisabled = false
            textHighlightObserver.start()
        } else {
            logger.info("Disabling copying highlighted text")
            UserDefaults.copyingOnHighlightIsDisabled = true
            textHighlightObserver.stop()
        }
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
