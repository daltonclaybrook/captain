import CaptainKit

extension InstallerError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .gitDirectoryMissingOrInvalid:
            return "Git directory missing or invalid"
        case .failedToCreateGitHooksDirectory:
            return "Failed to create git hooks directory"
        case .noConfigAtPath:
            return "No config file found at specified path"
        case .failedToParseConfig:
            return "Failed to parse config file"
        }
    }
}
