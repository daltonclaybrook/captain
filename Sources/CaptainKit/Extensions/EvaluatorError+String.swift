extension EvaluatorError: CustomStringConvertible {
    var description: String {
        switch self {
        case .invalidConfig:
            return "Invalid config for hook"
        case .noEvaluatorForHook:
            return "No evaluator for this hook"
        case .evaluationFailed(let description, let error):
            return "\(description)\n\(error.description.indented())"
        }
    }
}
