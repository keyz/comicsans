import SwiftUI

public struct ComicSansView: View {
    let text: String
    let padding: Int
    let horizontalAlignment: HorizontalAlignmentOption
    let verticalAlignment: VerticalAlignmentOption
    let debug: Bool

    public init(
        text: String,
        padding: Int,
        horizontalAlignment: HorizontalAlignmentOption,
        verticalAlignment: VerticalAlignmentOption,
        debug: Bool
    ) {
        self.text = text
        self.padding = padding
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.debug = debug
    }

    public var body: some View {
        VStack {
            if verticalAlignment == .bottom {
                Spacer()
            }

            Text(text)
                .font(.comicSans(size: 256))
                .foregroundStyle(Color(red: 1, green: 0, blue: 1))
                .minimumScaleFactor(0.001)
                .multilineTextAlignment(horizontalAlignment.textAlignment)
                .border(Color.blue, width: debug ? 1 : 0)
                .padding(CGFloat(padding)) // NOTE: use letter "j" to test the horizontal spacing

            if verticalAlignment == .top {
                Spacer()
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

    #Preview("lfg") {
        ContainerView(text: "lfg")
    }

    #Preview("bottom padding 0") {
        ContainerView(text: "j", padding: 0, verticalAlignment: .bottom)
    }

    #Preview("left padding 0") {
        ContainerView(text: "jason", padding: 0)
    }

    #Preview("tall character") {
        ContainerView(text: "Ö")
    }
#endif
