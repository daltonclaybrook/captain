import Foundation

extension String {
    internal var fullNSRange: NSRange {
        return NSRange(location: 0, length: utf16.count)
    }

    func indented(by count: Int = 1) -> String {
        let tabString = (0..<count).reduce(into: "") { result, _ in
            result += "\t"
        }
        return "\(tabString)\(replacingOccurrences(of: "\n", with: "\n\(tabString)"))"
    }
}
