import CaptainKit

//swiftlint:disable line_length
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
        case .gitHookExists(let hook):
            return "An existing unmanaged git hook was found (\(hook.rawValue)). Remove this hook manually, or re-run with --force."
        case .failedToInstallGitHook:
            return "An unknown error occurred when trying to install git hooks"
        }
    }
}
