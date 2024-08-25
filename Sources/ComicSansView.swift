import SwiftUI

struct ComicSansView: View {
    var text: String
    var padding: Int
    var horizontalAlignment: HorizontalAlignmentOption
    var verticalAlignment: VerticalAlignmentOption
    var debug: Bool

    var body: some View {
        VStack {
            if verticalAlignment == .bottom {
                Spacer()
            }

            Text(text)
                .font(.custom("Comic Sans MS", size: 256))
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

#Preview {
    ComicSansView(text: "Write something here and click generate", padding: 4, horizontalAlignment: .leading, verticalAlignment: .center, debug: false)
}
