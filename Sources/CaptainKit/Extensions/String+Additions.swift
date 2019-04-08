import Foundation

extension String {
    internal var fullNSRange: NSRange {
        return NSRange(location: 0, length: utf16.count)
    }
}
