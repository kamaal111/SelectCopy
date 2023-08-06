//
//  AXUIElement+extensions.swift
//  SelectCopy
//
//  Created by Kamaal M Farah on 03/08/2023.
//

import Cocoa
import Foundation
import KamaalLogger

private let logger = KamaalLogger(from: AXUIElement.self, failOnError: true)

extension AXUIElement {
    func getSelectedText() -> String? {
        getValue(for: .selectedText) as? String
    }

    func getAttributeNames() -> [String] {
        var attirbutes: CFArray?
        let error = AXUIElementCopyAttributeNames(self, &attirbutes)
        guard error == .success else { return [] }

        return (attirbutes as? [String]) ?? []
    }

    static var isTrustedToUseAccessibilty: Bool {
        AXIsProcessTrusted()
    }

    @discardableResult
    static func requestForAccess() -> Bool {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        return AXIsProcessTrustedWithOptions(options as CFDictionary?)
    }

    static var focusedElement: AXUIElement? {
        guard let value = systemWide.getValue(for: .focuseElement) else { return nil }

        return value as! AXUIElement
    }

    private func getValue(for attribute: AXAttributes) -> Any? {
        guard let value = getRawValue(for: attribute) else { return nil }
        guard let castedValue = castToUnderlyingType(value) else { return nil }

        return castedValue
    }

    private func getRawValue(for attribute: AXAttributes) -> AnyObject? {
        var value: AnyObject?
        let error = AXUIElementCopyAttributeValue(self, attribute.asCFString, &value)
        guard error == .success else { return nil }
        guard let value else {
            logger.debug("Get raw value error: \(error.rawValue)")
            return nil
        }

        return value
    }

    private func castToUnderlyingType(_ value: AnyObject) -> Any? {
        switch CFGetTypeID(value) {
        case AXUIElementGetTypeID(): return value as! AXUIElement
        case AXValueGetTypeID(): return (value as! AXValue).getValue()
        default: return value
        }
    }

    private static var systemWide = AXUIElementCreateSystemWide()
}

private enum AXAttributes {
    case selectedText
    case focuseElement

    var rawValue: String {
        switch self {
        case .focuseElement: return kAXFocusedUIElementAttribute
        case .selectedText: return "AXSelectedText"
        }
    }

    var asCFString: CFString { rawValue as CFString }
}

extension AXValue {
    func getValue() -> Any? {
        let type = getType()
        switch type {
        case .axError:
            var value = AXError.failure
            AXValueGetValue(self, type, &value)
            return value
        case .cgSize:
            var value: CGSize = .zero
            AXValueGetValue(self, type, &value)
            return value
        case .cgPoint:
            var value: CGPoint = .zero
            AXValueGetValue(self, type, &value)
            return value
        case .cgRect:
            var value: CGRect = .zero
            AXValueGetValue(self, type, &value)
            return value
        case .cfRange:
            var value = CFRange()
            AXValueGetValue(self, type, &value)
            return value
        case .illegal: return nil
        @unknown default: return nil
        }
    }

    private func getType() -> AXValueType {
        AXValueGetType(self)
    }
}
