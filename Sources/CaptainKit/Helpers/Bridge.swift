import Foundation

extension NSString {
    public func bridge() -> String {
        #if _runtime(_ObjC) || swift(>=4.1.50)
        return self as String
        #else
        return _bridgeToSwift()
        #endif
    }
}

extension String {
    public func bridge() -> NSString {
        #if _runtime(_ObjC) || swift(>=4.1.50)
        return self as NSString
        #else
        return NSString(string: self)
        #endif
    }
}
