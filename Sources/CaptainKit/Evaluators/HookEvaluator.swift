import Foundation

typealias ErrorStringType = Error & CustomStringConvertible

enum EvaluatorError: Error {
    case invalidConfig
    case noEvaluatorForHookName(String)
    case evaluationFailed(ErrorStringType)
}

protocol HookConfig {
    init?(parameters: [String: Any]?, arguments: [String])
}

protocol HookEvaluator {
    associatedtype Config: HookConfig
    associatedtype HookError: ErrorStringType

    var name: String { get }

    func evaluate(with config: Config) -> Result<(), HookError>
}

typealias EvaluateBlock = (_ parameters: [String: Any]?, _ arguments: [String]) -> Result<(), EvaluatorError>

final class EvaluatorRegistry {
    private var evaluators: [String: EvaluateBlock] = [:]

    func register<T: HookEvaluator>(evaluator: T) {
        evaluators[evaluator.name] = { parameters, arguments in
            guard let config = T.Config(parameters: parameters, arguments: arguments) else {
                return .failure(.invalidConfig)
            }
            let result = evaluator.evaluate(with: config)
            return result.mapError { .evaluationFailed($0) }
        }
    }

    func evaluate(hookName: String, parameters: [String: Any]?, arguments: [String]) -> Result<(), EvaluatorError> {
        guard let evaluator = evaluators[hookName] else {
            return .failure(.noEvaluatorForHookName(hookName))
        }
        return evaluator(parameters, arguments)
    }

    func evaluateCustomHook(withName name: String, parameters: [String: Any]?,
                            arguments: [String]) -> Result<(), EvaluatorError> {
        return .success(())
    }
}
