extension CustomHookEvaluatorError: CustomStringConvertible {
    var description: String {
        switch self {
        case .regexError(let error as ErrorStringType),
             .commandError(let error as ErrorStringType):
            return error.description
        }
    }
}
