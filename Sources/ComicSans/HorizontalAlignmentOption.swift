import SwiftUI

public enum HorizontalAlignmentOption: String, CaseIterable, Sendable {
    case leading
    case center
    case trailing

    var textAlignment: TextAlignment {
        switch self {
        case .leading:
            .leading
        case .center:
            .center
        case .trailing:
            .trailing
        }
    }
}
