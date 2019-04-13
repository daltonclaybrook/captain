import Foundation

typealias ErrorStringType = Error & CustomStringConvertible

enum EvaluatorError: Error {
    case invalidConfig
    case noEvaluatorForHook
    case evaluationFailed(hookDescription: String, error: ErrorStringType)
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

    static var name: String { get }
    var description: String { get }

    init(config: Config, context: EvaluationContext)
    func evaluate() -> Result<(), HookError>
}

typealias EvaluateBlock = (_ parameters: [String: Any]?, _ context: EvaluationContext) -> Result<(), EvaluatorError>

final class EvaluatorRegistry {
    private var evaluators: [String: EvaluateBlock] = [:]

    init() {
        register(CustomHookEvaluator.self)
    }

    func register<T: HookEvaluator>(_ type: T.Type) {
        evaluators[type.name] = { parameters, context in
            guard let config = T.Config(parameters: parameters) else {
                return .failure(.invalidConfig)
            }
            let evaluator = T(config: config, context: context)
            return evaluator.evaluate()
                .mapError { .evaluationFailed(hookDescription: evaluator.description, error: $0) }
        }
    }

    func evaluate(hook: Hook, context: EvaluationContext) -> Result<(), EvaluatorError> {
        let name = hook.custom ? CustomHookEvaluator.name : hook.name
        guard let evaluator = evaluators[name] else {
            return .failure(.noEvaluatorForHook)
        }
        return evaluator(hook.parameters, context)
    }
}
