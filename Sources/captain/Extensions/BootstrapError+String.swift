import CaptainKit

extension BootstrapError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .noDirectoryAtPath(let path):
            return "Directory does not exist at \(path)"
        case .pathIsNotADirectory(let path):
            return "The following path is not a directory: \(path)"
        case .notAGitRepository(let path):
            return "The following path is not a git repository: \(path)"
        case .configFileAlreadyExists(let path):
            return "A config file already exists at \(path)"
        case .failedToCreateConfigFile(let path):
            return "The config file could not be created at \(path)"
        }
    }
}
