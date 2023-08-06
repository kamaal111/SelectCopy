//
//  Shell+extensions.swift
//  Playground
//
//  Created by Kamaal M Farah on 06/08/2023.
//

import Foundation
import KamaalUtils
import KamaalExtensions

extension Shell {
    static func runAppIconGenerator(input: Data, output: URL) -> Result<String, Errors> {
        let fileManager = FileManager.default
        let temporaryFileURL = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("png")
        try! input.write(to: temporaryFileURL)
        defer { try? fileManager.removeItem(at: temporaryFileURL) }

        let appIconGeneratorPath = try! fileManager.findDirectoryOrFile(
            inDirectory: Bundle.main.resourceURL!,
            searchPath: "app-icon-generator"
        )!
            .relativePath
            .replacingOccurrences(of: " ", with: "\\ \\")
            .replacingOccurrences(of: ")", with: "\\)")
        let command = "\(appIconGeneratorPath) -o \(output.relativePath) -i \(temporaryFileURL.relativePath) -v"

        return zsh(command)
    }
}
