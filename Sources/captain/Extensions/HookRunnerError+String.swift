import CaptainKit

extension HookRunnerError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .testError(let path):
            return "current directory: \(path)"
        }
    }
}
