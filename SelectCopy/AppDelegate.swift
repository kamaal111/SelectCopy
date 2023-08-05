//
//  AppDelegate.swift
//  SelectCopy
//
//  Created by Kamaal M Farah on 03/08/2023.
//

import Cocoa
import SwiftUI
import Combine
import KamaalExtensions

// - MARK: AppDelegate

private let HIGHLIGHTED_TEXT_INTERVAL: TimeInterval = 0.01
private let HIGHLIGHTED_TEXT_DEBOUNCE_INTERVAL_IN_SECONDS = 0.3

final class AppDelegate: NSObject {
    @Published private var highlightedTextBuffer: String?

    private var statusItem: NSStatusItem!
    private var highlightedTextBufferSubscription = Set<AnyCancellable>()
    private let userData = UserData()
}

// - MARK: NSApplicationDelegate

extension AppDelegate: NSApplicationDelegate {
    func applicationDidFinishLaunching(_: Notification) {
        setupStatusItem()
        closeAllWindowsExceptForStatusBarWindow()
        observeTextHighlighting()
        observeHighlightedTextBuffer()
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

    private func observeTextHighlighting() {
        Timer.scheduledTimer(withTimeInterval: HIGHLIGHTED_TEXT_INTERVAL, repeats: true) { [weak self] _ in
            guard let self else { return }
            guard let focusedElement = AXUIElement.focusedElement else { return }
            guard let selectedText = focusedElement.getSelectedText() else { return }
            guard !selectedText.trimmingByWhitespacesAndNewLines.isEmpty else { return }
            guard selectedText != highlightedTextBuffer else { return }

            highlightedTextBuffer = selectedText
        }
    }

    private func observeHighlightedTextBuffer() {
        $highlightedTextBuffer
            .debounce(for: .seconds(HIGHLIGHTED_TEXT_DEBOUNCE_INTERVAL_IN_SECONDS), scheduler: DispatchQueue.global())
            .sink(receiveValue: { [weak self] value in
                guard let self else { return }
                guard let value else { return }

                storeHighlightedText(value)
            })
            .store(in: &highlightedTextBufferSubscription)
    }

    private func storeHighlightedText(_ highlightedText: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(highlightedText, forType: .string)
    }
}
