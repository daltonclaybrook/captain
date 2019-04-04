import Foundation

public enum BootstrapError: Error {
    case noDirectoryAtPath
    case pathIsNotADirectory
    case notAGitRepository
    case configFileExists
}

public struct Bootstrap {
    public init() {}

    public func bootstrapProject(atPath path: String) -> Result<(), BootstrapError> {
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        guard fileManager.fileExists(atPath: path, isDirectory: &isDirectory) else {
            return .failure(.noDirectoryAtPath)
        }
        guard isDirectory.boolValue else {
            return .failure(.pathIsNotADirectory)
        }

        let gitPath = path.bridge().appendingPathComponent(".git")
        guard fileManager.fileExists(atPath: gitPath, isDirectory: &isDirectory), isDirectory.boolValue else {
            return .failure(.notAGitRepository)
        }

        let configPath = path.bridge().appendingPathComponent(".captain.yml")
        guard !fileManager.fileExists(atPath: configPath, isDirectory: nil) else {
            return .failure(.configFileExists)
        }

        // TODO: copy template.yml in bundle
        return .success(())
    }
}
