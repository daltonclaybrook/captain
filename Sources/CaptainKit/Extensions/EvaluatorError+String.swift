extension EvaluatorError: CustomStringConvertible {
    var description: String {
        switch self {
        case .invalidConfig:
            return "Invalid config for hook"
        case .noEvaluatorForHook:
            return "This hook does not exist"
        case .evaluationFailed(let description, let error):
            return "\(description)\n\(error.description.indented())"
        }
    }
}
