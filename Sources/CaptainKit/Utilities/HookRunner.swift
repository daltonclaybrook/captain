import Foundation
import Yams
import os

public enum HookRunnerError: Error {
    case testError(String)
}

public struct HookRunner {
    public let gitHook: String

    public init(gitHook: String) {
        self.gitHook = gitHook
    }

    public func run() -> Result<(), HookRunnerError> {
        let fileManager = FileManager.default
        return .failure(.testError(fileManager.currentDirectoryPath))
    }
}
