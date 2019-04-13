import Foundation

enum CustomHookEvaluatorError: Error {
    case regexError(RegexEvaluatorError)
    case commandError(CommandEvaluatorError)
}

final class CustomHookEvaluator {
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
