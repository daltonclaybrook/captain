import CaptainKit

extension HookRunnerError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .testError(let errorString):
            return "test error: \(errorString)"
        case .failedToParseConfig:
            return "Failed to parse .captain.yml"
        }
    }
}
