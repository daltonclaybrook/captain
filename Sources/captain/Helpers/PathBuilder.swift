import CaptainKit
import Foundation

struct PathBuilder {
    static func fullPath(from path: String) -> String {
        if path.hasPrefix("/") {
            return path
        } else {
            let root = FileManager.default.currentDirectoryPath
            return NSString.path(withComponents: [root, path]).bridge().standardizingPath
        }
    }
}
