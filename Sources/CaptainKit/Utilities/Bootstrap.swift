import Foundation

public enum BootstrapError: Error {
    case noDirectoryAtPath(String)
    case pathIsNotADirectory(String)
    case notAGitRepository(String)
    case configFileAlreadyExists(String)
    case failedToCreateConfigFile(String)
}

public struct Bootstrap {
    private let templateFileContents = """
source:
- https://github.com/daltonclaybrook/captain

hooks:
- no_push_to_master
- no_fit_or_fdescribe

custom_hooks:
  no_fit_or_fdescribe:
    git_hook: pre-commit
    message: "Do not commit calls to `fit(...)` or `fdescribe(...)`"
    regex: '^\\+\\s*(?:fdescribe|fit)\\(\\".*\\"\\)'

"""

    public init() {}

    /// Returns the file path of the newly created config file, or an error
    public func createConfigFile(atPath path: String) -> Result<String, BootstrapError> {
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        guard fileManager.fileExists(atPath: path, isDirectory: &isDirectory) else {
            return .failure(.noDirectoryAtPath(path))
        }
        guard isDirectory.boolValue else {
            return .failure(.pathIsNotADirectory(path))
        }

        let gitPath = path.bridge().appendingPathComponent(".git")
        guard fileManager.fileExists(atPath: gitPath, isDirectory: &isDirectory), isDirectory.boolValue else {
            return .failure(.notAGitRepository(path))
        }

        let configPath = path.bridge().appendingPathComponent(".captain.yml")
        guard !fileManager.fileExists(atPath: configPath, isDirectory: nil) else {
            return .failure(.configFileAlreadyExists(configPath))
        }

        guard fileManager.createFile(
            atPath: configPath,
            contents: templateFileContents.data(using: .utf8),
            attributes: nil) else {
            return .failure(.failedToCreateConfigFile(configPath))
        }

        return .success(configPath)
    }
}
