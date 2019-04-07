import CaptainKit
import Foundation

extension NSString {
    func absolutePathRepresentation(rootDirectory: String = FileManager.default.currentDirectoryPath) -> String {
        if isAbsolutePath { return bridge() }
        #if os(Linux)
        //swiftlint:disable:next force_unwrapping line_length
        return NSURL(fileURLWithPath: NSURL.fileURL(withPathComponents: [rootDirectory, bridge()])!.path).standardizingPath!.path
        #else
        return NSString.path(withComponents: [rootDirectory, bridge()]).bridge().standardizingPath
        #endif
    }
}
