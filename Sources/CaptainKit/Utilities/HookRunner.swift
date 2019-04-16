import Foundation
import Yams

public enum HookRunnerError: Error {
    case testError(String)
    case failedToParseConfig
    case hooksFailedEvaluation(String)
}

struct NameAndResult {
    let hookName: String
    var result: Result<(), EvaluatorError>
}

public struct HookRunner {
    public let gitHook: String
    public let arguments: [String]
    private let registry = EvaluatorRegistry.registryWithAllHooks()

    public init(gitHook: String, arguments: [String]) {
        self.gitHook = gitHook
        self.arguments = arguments
    }

    public func run() -> Result<(), HookRunnerError> {
        let fileManager = FileManager.default
        let configPath = fileManager.currentDirectoryPath.bridge().appendingPathComponent(".captain.yml")

        guard let configData = fileManager.contents(atPath: configPath),
            let configString = String(data: configData, encoding: .utf8),
            let configDict = try? Yams.load(yaml: configString) as? [String: Any] else {
                return .failure(.failedToParseConfig)
        }

        let config = Config(dict: configDict)
        let context = EvaluationContext(repoPath: fileManager.currentDirectoryPath, gitHook: gitHook,
                                        arguments: arguments, regexPaths: config.regexPaths)
        let hookResults = config.hooks.map { hook -> NameAndResult in
            let result = registry.evaluate(hook: hook, context: context)
            return NameAndResult(hookName: hook.name, result: result)
        }

        return makeFinalResult(from: hookResults)
    }

    // MARK: - Helpers

    private func makeFinalResult(from results: [NameAndResult]) -> Result<(), HookRunnerError> {
        let failureStrings: [String] = results.compactMap { result in
            let errorString = result.result.error?.description
            return errorString.map {
                "\(result.hookName): \($0)"
            }
        }

        guard !failureStrings.isEmpty else { return .success(()) }
        let output = """
        The following failures occurred for the "\(gitHook)" git hook:

        \(failureStrings.joined(separator: "\n\n").indented())
        """
        return .failure(.hooksFailedEvaluation(output))
    }
}
