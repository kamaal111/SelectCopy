//
//  TextHighlightObserver.swift
//  SelectCopy
//
//  Created by Kamaal M Farah on 05/08/2023.
//

import Cocoa
import Combine
import KamaalExtensions

private let HIGHLIGHTED_TEXT_INTERVAL: TimeInterval = 0.01
private let HIGHLIGHTED_TEXT_DEBOUNCE_INTERVAL_IN_SECONDS = 0.3

final class TextHighlightObserver {
    @Published private var highlightedTextBuffer: String?

    private var highlightedTextBufferSubscription = Set<AnyCancellable>()
    private var observerTimer: Timer?

    func start() {
        observeTextHighlighting()
        observeHighlightedTextBuffer()
    }

    func stop() {
        observerTimer?.invalidate()
        observerTimer = nil
        highlightedTextBuffer = nil
    }

    private func observeTextHighlighting() {
        observerTimer = Timer
            .scheduledTimer(withTimeInterval: HIGHLIGHTED_TEXT_INTERVAL, repeats: true) { [weak self] _ in
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
