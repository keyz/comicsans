import ArgumentParser
import SwiftUI

enum HorizontalAlignmentOption: String, CaseIterable, ExpressibleByArgument {
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