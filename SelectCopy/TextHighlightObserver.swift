//
//  TextHighlightObserver.swift
//  SelectCopy
//
//  Created by Kamaal M Farah on 05/08/2023.
//

import Cocoa
import Combine
import KamaalLogger

private let HIGHLIGHTED_TEXT_INTERVAL: TimeInterval = 0.01
private let HIGHLIGHTED_TEXT_DEBOUNCE_INTERVAL_IN_SECONDS = 0.3

final class TextHighlightObserver {
    @Published private var highlightedTextBuffer: String?

    private var highlightedTextBufferSubscription = Set<AnyCancellable>()
    private var observerTimer: Timer?
    private var hasStarted = false
    private let logger = KamaalLogger(from: TextHighlightObserver.self, failOnError: true)

    func start() {
        guard !hasStarted else {
            logger.debug("Starting but already started")
            return
        }

        logger.info("Starting observer")
        hasStarted = true
        observeTextHighlighting()
        observeHighlightedTextBuffer()
    }

    func stop() {
        logger.info("Stopping observer")
        observerTimer?.invalidate()
        observerTimer = nil
        highlightedTextBuffer = nil
        hasStarted = false
    }

    private func observeTextHighlighting() {
        assert(observerTimer == nil)
        observerTimer = Timer
            .scheduledTimer(withTimeInterval: HIGHLIGHTED_TEXT_INTERVAL, repeats: true) { [weak self] _ in
                guard let self else { return }
                guard let focusedElement = AXUIElement.focusedElement else { return }
                guard let selectedText = focusedElement.getSelectedText() else { return }
                guard !selectedText.isEmpty else { return }
                guard selectedText != highlightedTextBuffer else { return }

                DispatchQueue.highlightedTextBuffer.async { [weak self] in
                    guard let self else { return }

                    highlightedTextBuffer = selectedText
                }
            }
    }

    private func observeHighlightedTextBuffer() {
        $highlightedTextBuffer
            .debounce(
                for: .seconds(HIGHLIGHTED_TEXT_DEBOUNCE_INTERVAL_IN_SECONDS),
                scheduler: DispatchQueue.highlightedTextBuffer
            )
            .sink(receiveValue: { value in
                DispatchQueue.highlightedTextBuffer.async { [weak self] in
                    guard let self else { return }
                    guard let value else { return }

                    storeHighlightedText(value)
                }
            })
            .store(in: &highlightedTextBufferSubscription)
    }

    private func storeHighlightedText(_ highlightedText: String) {
        logger.debug("Storing the text:\n\(highlightedText)")
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(highlightedText, forType: .string)
    }
}
