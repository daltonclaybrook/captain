import Foundation
import Yams

public enum InstallerError: Error {
    case gitDirectoryMissingOrInvalid
    case failedToCreateGitHooksDirectory
    case noConfigAtPath
    case failedToParseConfig
    case gitHookExists(GitHook)
    case failedToInstallGitHook
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

        guard let configData = fileManager.contents(atPath: configPath),
            let configString = String(data: configData, encoding: .utf8),
            (try? Yams.load(yaml: configString) as? [String: Any]) != nil else {
            return .failure(.failedToParseConfig)
        }

        // executable permissions
        let filePermission: NSNumber = 0o755
        for hook in GitHook.allCases {
            let gitHookPath = hooksPath.bridge().appendingPathComponent(hook.rawValue)
            let script = scriptContents(for: hook)
            if force || !fileManager.fileExists(atPath: gitHookPath) {
                fileManager.createFile(
                    atPath: gitHookPath,
                    contents: script.data(using: .utf8),
                    attributes: [.posixPermissions: filePermission]
                )
            } else if let contents = fileManager.contents(atPath: gitHookPath),
                let stringContents = String(data: contents, encoding: .utf8) {
                if stringContents != script {
                    return .failure(.gitHookExists(hook))
                }
            } else {
                return .failure(.failedToInstallGitHook)
            }
        }

        return .success(())
    }

    // MARK: - Helpers

    private func scriptContents(for hook: GitHook) -> String {
        return """
        #!/bin/bash
        # Auto-generated by Captain. Do not edit.
        captain run \(hook.rawValue) "$@"

        """
    }
}
