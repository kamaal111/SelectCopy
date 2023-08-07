//
//  DispatchQueues.swift
//  SelectCopy
//
//  Created by Kamaal M Farah on 07/08/2023.
//

import Foundation

extension DispatchQueue {
    static let highlightedTextBuffer = DispatchQueue(
        label: makeLabel("highlighted_text_buffer"),
        qos: .background
    )

    private static func makeLabel(_ key: String) -> String {
        "\(Bundle.main.bundleIdentifier!).queues.\(key)"
    }
}
