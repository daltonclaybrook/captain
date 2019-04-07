import Foundation
import Yams

public enum InstallerError: Error {
    case gitDirectoryMissingOrInvalid
    case failedToCreateGitHooksDirectory
    case noConfigAtPath
    case failedToParseConfig
}

public struct Installer {
    public let projectPath: String
    public let configPath: String
    public let force: Bool

    public init(projectPath: String, configPath: String, force: Bool) {
        self.projectPath = projectPath
        self.configPath = configPath
        self.force = force
    }

    public func install() -> Result<(), InstallerError> {
        let fileManager = FileManager.default
        let gitPath = projectPath.bridge().appendingPathComponent(".git")
        var isDirectory: ObjCBool = false
        guard fileManager.fileExists(atPath: gitPath, isDirectory: &isDirectory), isDirectory.boolValue else {
            return .failure(.gitDirectoryMissingOrInvalid)
        }

        let hooksPath = gitPath.bridge().appendingPathComponent("hooks")
        do {
            try fileManager.createDirectory(atPath: hooksPath, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return .failure(.failedToCreateGitHooksDirectory)
        }

        guard fileManager.fileExists(atPath: configPath) else {
            return .failure(.noConfigAtPath)
        }

        let decoder = YAMLDecoder()
        guard let configData = fileManager.contents(atPath: configPath),
            let configString = String(data: configData, encoding: .utf8),
            let config = try? decoder.decode(Config.self, from: configString) else {
            return .failure(.failedToParseConfig)
        }

        print(config)
        return .success(())
    }
}
