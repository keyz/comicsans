import SwiftUI

public struct ComicSansView: View {
    let text: String
    let padding: Int
    let horizontalAlignment: HorizontalAlignmentOption
    let verticalAlignment: VerticalAlignmentOption
    let lineHeightMultiple: CGFloat
    let debug: Bool

    public init(
        text: String,
        padding: Int,
        horizontalAlignment: HorizontalAlignmentOption,
        verticalAlignment: VerticalAlignmentOption,
        lineHeightMultiple: CGFloat = 1,
        debug: Bool = false
    ) {
        self.text = text
        self.padding = padding
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.lineHeightMultiple = lineHeightMultiple
        self.debug = debug
    }

    public var body: some View {
        VStack(spacing: 0) {
            if verticalAlignment != .top {
                if debug, #available(macOS 14.0, *) {
                    Spacer(minLength: 0)
                        .background(Color.yellow.opacity(0.9).containerRelativeFrame(.horizontal))
                } else {
                    Spacer(minLength: 0)
                }
            }

            Text(text)
                .environment(\._lineHeightMultiple, lineHeightMultiple)
                .font(.comicSans(size: 256))
                .foregroundStyle(Color(red: 1, green: 0, blue: 1))
                .minimumScaleFactor(0.001)
                .multilineTextAlignment(horizontalAlignment.textAlignment)
                .border(Color.blue.opacity(0.9), width: debug ? 1 : 0)
                .padding(CGFloat(padding)) // NOTE: use letter "j" to test the horizontal spacing

            if verticalAlignment != .bottom {
                if debug, #available(macOS 14.0, *) {
                    Spacer(minLength: 0)
                        .background(Color.yellow.opacity(0.9).containerRelativeFrame(.horizontal))
                } else {
                    Spacer(minLength: 0)
                }
            }
        }
        .frame(width: 320, height: 320)
    }
}

#if DEBUG
    private struct ContainerView: View {
        @State var text: String
        @State var padding: Int = 4
        @State var horizontalAlignment: HorizontalAlignmentOption = .leading
        @State var verticalAlignment: VerticalAlignmentOption = .center
        @State var lineHeightMultiple: CGFloat = 1
        @State var debug: Bool = false

        var controlPanel: some View {
            VStack {
                TextField("Text", text: $text, axis: .vertical)
                    .lineLimit(2 ... 5)
                    .focusable(false)

                Slider(value: $padding.double, in: 0 ... 24, step: 4) {
                    Text("Padding: \(padding, specifier: "%02d")").monospacedDigit()
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("24")
                }

                Picker("Horizontal align", selection: $horizontalAlignment) {
                    Text("Leading").tag(HorizontalAlignmentOption.leading)
                    Text("Center").tag(HorizontalAlignmentOption.center)
                    Text("Trailing").tag(HorizontalAlignmentOption.trailing)
                }
                .pickerStyle(.segmented)

                Picker("Vertical align", selection: $verticalAlignment) {
                    Text("Top").tag(VerticalAlignmentOption.top)
                    Text("Center").tag(VerticalAlignmentOption.center)
                    Text("Bottom").tag(VerticalAlignmentOption.bottom)
                }
                .pickerStyle(.segmented)

                Slider(value: $lineHeightMultiple, in: 0.86 ... 1.0, step: 0.01) {
                    Text("lineHeightMultiple: \(lineHeightMultiple, specifier: "%.02f")").monospacedDigit()
                } minimumValueLabel: {
                    Text("0.86")
                } maximumValueLabel: {
                    Text("1.00")
                }

                Toggle(isOn: $debug) {
                    Text("Debug")
                }
            }
        }

        var body: some View {
            VStack {
                VStack {
                    VStack {
                        ComicSansView(
                            text: text,
                            padding: padding,
                            horizontalAlignment: horizontalAlignment,
                            verticalAlignment: verticalAlignment,
                            lineHeightMultiple: lineHeightMultiple,
                            debug: debug
                        )
                    }
                    .padding(1)
                    .border(Color(red: 1, green: 0, blue: 1), width: 1)
                }
                .padding()

                controlPanel
                    .frame(maxWidth: 320)
                    .padding()
            }
        }
    }

    private extension Int {
        var double: Double {
            get { Double(self) }
            set { self = Int(newValue) }
        }
    }

    #Preview("Default") {
        ContainerView(text: "Write something here and click generate")
    }

    #Preview("Zero-height spacer") {
        ContainerView(
            text: "Write something here and click generate. This will be longer than usual. I need a few more lines of text. And a bit more. How about now? One more line? And one more?",
            padding: 4,
            horizontalAlignment: .leading,
            verticalAlignment: .center,
            debug: true
        )
    }

    #Preview("\"lfg\"") {
        ContainerView(text: "lfg")
    }

    #Preview("Bottom padding 0") {
        ContainerView(text: "j", padding: 0, verticalAlignment: .bottom)
    }

    #Preview("Left padding 0") {
        ContainerView(text: "jason", padding: 0)
    }

    #Preview("Tall character") {
        ContainerView(text: "Ö")
    }

    #Preview("Chinese") {
        ContainerView(text: "好的")
    }

    #Preview("Mixed conent") {
        ContainerView(text: "ok 好")
    }
#endif
