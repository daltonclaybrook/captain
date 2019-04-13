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

    func evaluate(with config: CustomHookConfig, context: EvaluationContext) -> Result<(), CustomHookEvaluatorError> {
        guard context.gitHook == config.gitHook else {
            // This rule does not apply for this git hook
            return .success(())
        }
        if let regex = config.regex {
            let evaluator = RegexEvaluator(repoPath: context.repoPath, regex: regex)
            let result = evaluator.evaluate()
            if let error = result.error {
                return .failure(.regexError(error))
            }
        }
        if let command = config.command {
            let evaluator = CommandEvaluator(command: command)
            let result = evaluator.evaluate()
            if let error = result.error {
                return .failure(.commandError(error))
            }
        }
        return .success(())
    }
}

extension CustomHookConfig: HookConfig {
    init?(parameters: [String: Any]?) {
        guard let parameters = parameters,
            let gitHook = parameters["git_hook"] as? String,
            let message = parameters["message"] as? String else { return nil }
        self.gitHook = gitHook
        self.message = message
        self.regex = parameters["regex"] as? String
        self.command = parameters["command"] as? String
    }
}
