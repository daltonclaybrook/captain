import Foundation

typealias ErrorStringType = Error & CustomStringConvertible

enum EvaluatorError: Error {
    case invalidConfig
    case noEvaluatorForHookName(String)
    case evaluationFailed(ErrorStringType)
}

protocol HookConfig {
    init?(parameters: [String: Any]?)
}

struct EvaluationContext {
    let repoPath: String
    let gitHook: String
    let arguments: [String]
}

protocol HookEvaluator {
    associatedtype Config: HookConfig
    associatedtype HookError: ErrorStringType

    var name: String { get }

    func evaluate(with config: Config, context: EvaluationContext) -> Result<(), HookError>
}

typealias EvaluateBlock = (_ parameters: [String: Any]?, _ context: EvaluationContext) -> Result<(), EvaluatorError>

final class EvaluatorRegistry {
    private var evaluators: [String: EvaluateBlock] = [:]

    init() {
        register(evaluator: CustomHookEvaluator())
    }

    func register<T: HookEvaluator>(evaluator: T) {
        evaluators[evaluator.name] = { parameters, context in
            guard let config = T.Config(parameters: parameters) else {
                return .failure(.invalidConfig)
            }
            let result = evaluator.evaluate(with: config, context: context)
            return result.mapError { .evaluationFailed($0) }
        }
    }

    func evaluate(hookName: String, parameters: [String: Any]?,
                  context: EvaluationContext) -> Result<(), EvaluatorError> {
        guard let evaluator = evaluators[hookName] else {
            return .failure(.noEvaluatorForHookName(hookName))
        }
        return evaluator(parameters, context)
    }

    func evaluateCustomHook(name: String, parameters: [String: Any]?,
                            context: EvaluationContext) -> Result<(), EvaluatorError> {
        guard let evaluator = evaluators[CustomHookEvaluator.name] else {
            fatalError("Missing custom hook evaluator")
        }
        return evaluator(parameters, context)
    }
}
