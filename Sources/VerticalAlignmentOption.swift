import ArgumentParser

enum VerticalAlignmentOption: String, CaseIterable, ExpressibleByArgument {
    case top
    case center
    case bottom
}