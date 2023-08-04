//
//  AXUIElement+extensions.swift
//  SelectCopy
//
//  Created by Kamaal M Farah on 03/08/2023.
//

import Cocoa

extension AXUIElement {
    private static var systemWide = AXUIElementCreateSystemWide()

    static var focusedElement: AXUIElement? {
        systemWide.element(for: kAXFocusedUIElementAttribute)
    }

    private func element(for attribute: String) -> AXUIElement? {
        guard let rawValue = rawValue(for: attribute) else { return nil }
        guard CFGetTypeID(rawValue) == AXUIElementGetTypeID() else { return nil }

        return (rawValue as! AXUIElement)
    }

    private func rawValue(for attribute: String) -> AnyObject? {
        var rawValue: AnyObject?
        let error = AXUIElementCopyAttributeValue(self, attribute as CFString, &rawValue)
        guard error == .success else { return nil }

        return rawValue
    }
}
