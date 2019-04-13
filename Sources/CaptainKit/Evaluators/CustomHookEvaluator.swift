import Foundation

enum CustomHookEvaluatorError: Error {
    case regexError(RegexEvaluatorError)
    case commandError(CommandEvaluatorError)
}

struct CustomHookConfig {
    let gitHook: String
    let message: String
    let regex: String?
    let command: String?
}

final class CustomHookEvaluator: HookEvaluator {
    static let name = "com.captain.custom_hook_evaluator"

    var name: String {
        return CustomHookEvaluator.name
    }

    func evaluate(with config: CustomHookConfig) -> Result<(), CustomHookEvaluatorError> {
        return .success(())
    }
}

extension CustomHookConfig: HookConfig {
    init?(parameters: [String: Any]?, arguments: [String]) {
        guard let parameters = parameters,
            let gitHook = parameters["git_hook"] as? String,
            let message = parameters["message"] as? String else { return nil }
        self.gitHook = gitHook
        self.message = message
        self.regex = parameters["regex"] as? String
        self.command = parameters["command"] as? String
    }
}
