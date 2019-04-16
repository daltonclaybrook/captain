extension CommandEvaluatorError: CustomStringConvertible {
    var description: String {
        switch self {
        case .commandFailed(let error):
            return "Command failed: \(error)"
        }
    }
}
