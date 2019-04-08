extension RegexEvaluatorError: CustomStringConvertible {
    var description: String {
        switch self {
        case .gitProcessFailed:
            return "The git process failed"
        case .invalidRegex(let pattern):
            return "The regex pattern is invalid: \(pattern)"
        case .matchesFound(let files):
            return "Found matches in the following staged files:\n\(files.joined(separator: "\n"))"
        }
    }
}
