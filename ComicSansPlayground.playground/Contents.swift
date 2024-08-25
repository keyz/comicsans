import PlaygroundSupport
import SwiftUI

struct RootView: View {
    @State private var padding: CGFloat = 4
    @State private var text: String = "Write something here and click generate"
    @State private var horizontalAlignment: TextAlignment = .leading
    @State private var verticalAlignment: VerticalAlignmentOption = .center
    @State private var debug: Bool = false
    @State private var renderedImage = Image(systemName: "photo")
    @Environment(\.displayScale) var displayScale

    var resultView: some View {
        VStack {
            if verticalAlignment == .bottom {
                Spacer()
            }

            Text(text)
                .font(.custom("Comic Sans MS", size: 256))
                .foregroundStyle(Color(red: 1, green: 0, blue: 1))
                .minimumScaleFactor(0.001)
                .multilineTextAlignment(horizontalAlignment)
                .border(Color.blue, width: debug ? 1 : 0)
                .padding(padding) // NOTE: use letter "j" to test the horizontal spacing

            if verticalAlignment == .top {
                Spacer()
            }
        }
        .frame(width: 320, height: 320)
    }

    var body: some View {
        VStack {
            resultView
        }
        .padding(1)
        .border(Color(red: 1, green: 0, blue: 1), width: 1)

        ControlPanel(
            padding: $padding,
            text: $text,
            horizontalAlignment: $horizontalAlignment,
            verticalAlignment: $verticalAlignment,
            debug: $debug
        )
    }

    @MainActor func render() {
        let renderer = ImageRenderer(content: resultView)
        renderer.scale = displayScale

        if let nsImage = renderer.nsImage {
            renderedImage = Image(nsImage: nsImage)
        }
    }
}

struct ControlPanel: View {
    @Binding var padding: CGFloat
    @Binding var text: String
    @Binding var horizontalAlignment: TextAlignment
    @Binding var verticalAlignment: VerticalAlignmentOption
    @Binding var debug: Bool

    var formattedPadding: String {
        String(format: "%.0f", padding)
    }

    var body: some View {
        VStack {
            VStack {
                TextEditor(text: $text)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(5, reservesSpace: true)
                    .padding()
                Spacer()
                Slider(value: $padding, in: 0 ... 24, step: 4) {
                    Text("Padding: \(formattedPadding)").monospacedDigit()
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("24")
                }
                Spacer()
                Picker("Horizontal align", selection: $horizontalAlignment) {
                    Text("Leading").tag(TextAlignment.leading)
                    Text("Center").tag(TextAlignment.center)
                    Text("Trailing").tag(TextAlignment.trailing)
                }
                .pickerStyle(.palette)
                Spacer()
                Picker("Vertical align", selection: $verticalAlignment) {
                    Text("Top").tag(VerticalAlignmentOption.top)
                    Text("Center").tag(VerticalAlignmentOption.center)
                    Text("Bottom").tag(VerticalAlignmentOption.bottom)
                }
                .pickerStyle(.palette)
                Spacer()
                Toggle(isOn: $debug) {
                    Text("Debug")
                }
            }
            .padding()
        }
    }
}

enum VerticalAlignmentOption {
    case top
    case center
    case bottom
}

PlaygroundPage.current.setLiveView(RootView())
