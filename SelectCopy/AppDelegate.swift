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
}

// - MARK: NSApplicationDelegate

extension AppDelegate: NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusItem()
        closeAllWindowsExceptForStatusBarWindow()
        observeFocusedElement()
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

    private func observeFocusedElement() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            guard let selectedText = AXUIElement.focusedElement?.getValue(for: .selectedText),
                  let selectedText = selectedText as? String,
                  !selectedText.isEmpty else { return }

            print("🐸🐸🐸🐸🐸🐸🐸🐸🐸🐸🐸")
            print(selectedText)
            print("🐸🐸🐸🐸🐸🐸🐸🐸🐸🐸🐸")
        }
    }
}
