//
//  AppLogoCreatorScreen.swift
//  Playground
//
//  Created by Kamaal M Farah on 06/08/2023.
//

import SwiftUI
import KamaalUI
import KamaalUtils
import KamaalExtensions

let PLAYGROUND_SELECTABLE_COLORS: [Color] = [
    .black,
    .accentColor,
]

struct AppLogoCreatorScreen: View {
    @State private var viewModel = ViewModel()

    var body: some View {
        KScrollableForm {
            KJustStack {
                logoSection
                customizationSection
            }
            .padding(.all, 16)
            .ktakeSizeEagerly(alignment: .topLeading)
        }
    }

    private var logoSection: some View {
        KSection(header: "Logo") {
            HStack(alignment: .top) {
                viewModel.logoView(
                    size: viewModel.previewLogoSize,
                    cornerRadius: viewModel.hasCurves ? viewModel.curvedCornersSize : 0
                )
                Spacer()
                VStack(alignment: .leading) {
                    HStack {
                        KFloatingTextField(
                            text: $viewModel.exportLogoSize,
                            title: "Export logo size",
                            textFieldType: .numbers
                        )
                        HStack {
                            Button(action: { viewModel.setRecommendedAppIconSize() }) {
                                Text("Icon size")
                                    .foregroundColor(.accentColor)
                            }
                            .disabled(viewModel.disableAppIconSizeButton)
                        }
                        .padding(.bottom, -8)
                    }
                    HStack {
                        Button(action: viewModel.exportLogoAsIconSet) {
                            Text("Export logo as IconSet")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
        }
    }

    private var customizationSection: some View {
        KSection(header: "Customization") {
            AppLogoColorFormRow(title: "Has a background") {
                Toggle(viewModel.hasABackground ? "Yup" : "Nope", isOn: $viewModel.hasABackground)
            }
            .padding(.bottom, 16)
            .padding(.top, 8)
            AppLogoColorSelector(color: $viewModel.backgroundColor, title: "Background color")
                .disabled(!viewModel.hasABackground)
                .padding(.bottom, 16)
            AppLogoColorSelector(color: $viewModel.primaryColor, title: "Primary color")
                .padding(.bottom, 16)
            AppLogoColorFormRow(title: "Has curves") {
                Toggle(viewModel.hasCurves ? "Yup" : "Nope", isOn: $viewModel.hasCurves)
            }
            .padding(.bottom, 16)
            .disabled(!viewModel.hasABackground)
            AppLogoColorFormRow(title: "Curve size") {
                Stepper("\(Int(viewModel.curvedCornersSize))", value: $viewModel.curvedCornersSize)
            }
            .disabled(viewModel.hasCurves || !viewModel.hasABackground)
        }
    }
}

@Observable
private final class ViewModel {
    var curvedCornersSize: CGFloat = 16
    var hasABackground = true
    var hasCurves = true
    var backgroundColor = PLAYGROUND_SELECTABLE_COLORS[0]
    var primaryColor = PLAYGROUND_SELECTABLE_COLORS[1]
    var exportLogoSize = "800" {
        didSet {
            let filteredExportLogoSize = exportLogoSize.filter(\.isNumber)
            if exportLogoSize != filteredExportLogoSize {
                exportLogoSize = filteredExportLogoSize
            }
        }
    }

    let previewLogoSize: CGFloat = 150
    private let fileManager = FileManager.default

    enum Errors: Error {
        case conversionFailure
    }

    var disableAppIconSizeButton: Bool { exportLogoSize == "800" }

    func logoView(size: CGFloat, cornerRadius: CGFloat) -> some View {
        AppLogo(
            size: size,
            backgroundColor: hasABackground ? backgroundColor : .white.opacity(0),
            primaryColor: primaryColor,
            curvedCornersSize: cornerRadius
        )
    }

    func exportLogoAsIconSet() {
        let temporaryDirectory = fileManager.temporaryDirectory
        Task {
            let data = try! await getLogoViewImageData()
            let appIconScriptResult = try! Shell
                .runAppIconGenerator(input: data, output: temporaryDirectory)
                .get()
            assert(appIconScriptResult.splitLines.last!.hasPrefix("done creating icons"))

            let iconSetName = "AppIcon.appiconset"
            let iconSetURL = try! fileManager
                .findDirectoryOrFile(inDirectory: temporaryDirectory, searchPath: iconSetName)!
            defer { try? fileManager.removeItem(at: iconSetURL) }

            let panel = try! await SavePanel.save(filename: iconSetName).get()
            let saveURL = await panel.url!
            if fileManager.fileExists(atPath: saveURL.path) {
                try? fileManager.removeItem(at: saveURL)
            }

            try! fileManager.moveItem(at: iconSetURL, to: saveURL)
        }
    }

    func setRecommendedAppIconSize() {
        withAnimation { exportLogoSize = "800" }
    }

    @MainActor
    private func getLogoViewImageData() async throws -> Data {
        let data = ImageRenderer(content: logoToExport)
            .nsImage?
            .tiffRepresentation
        guard let data else { throw Errors.conversionFailure }

        let pngRepresentation = NSBitmapImageRep(data: data)?
            .representation(using: .png, properties: [:])
        guard let pngRepresentation else { throw Errors.conversionFailure }

        return pngRepresentation
    }

    private var logoToExport: some View {
        let size = Double(exportLogoSize)!.cgFloat
        return logoView(size: size, cornerRadius: hasCurves ? curvedCornersSize * (size / previewLogoSize) : 0)
    }
}

#Preview {
    AppLogoCreatorScreen()
}
