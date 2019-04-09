import Foundation
import Yams

public enum HookRunnerError: Error {
    case testError(String)
    case failedToParseConfig
    case hooksFailedEvaluation(String)
}

struct EvaluationResults {
    let hookName: String
    let message: String
    var regex: Result<(), RegexEvaluatorError>?
    var command: Result<(), CommandEvaluatorError>?

    init(hookName: String, message: String) {
        self.hookName = hookName
        self.message = message
    }
}

public struct HookRunner {
    public let gitHook: String
    public let arguments: String

    public init(gitHook: String, arguments: String) {
        self.gitHook = gitHook
        self.arguments = arguments
    }

    public func run() -> Result<(), HookRunnerError> {
        let fileManager = FileManager.default
        let configPath = fileManager.currentDirectoryPath.bridge().appendingPathComponent(".captain.yml")

        let decoder = YAMLDecoder()
        guard let configData = fileManager.contents(atPath: configPath),
            let configString = String(data: configData, encoding: .utf8),
            let config = try? decoder.decode(Config.self, from: configString) else {
                return .failure(.failedToParseConfig)
        }

        // TODO: Run hooks provided out of the box by Captain

        let customHooks = config.customHooks ?? [:]
        var results: [EvaluationResults] = []
        for (name, hook) in customHooks where hook.gitHook == gitHook {
            var result = EvaluationResults(hookName: name, message: hook.message)

            // Run regex evaluator if necessary
            if let regex = hook.regex {
                let evaluator = RegexEvaluator(repoPath: fileManager.currentDirectoryPath, regex: regex)
                result.regex = evaluator.evaluate()
            }

            // Run command evaluator if necessary
            if let command = hook.run {
                let evaluator = CommandEvaluator(command: command)
                result.command = evaluator.evaluate()
            }

            results.append(result)
        }

        return makeFinalResult(from: results)
    }

    // MARK: - Helpers

    private func makeFinalResult(from results: [EvaluationResults]) -> Result<(), HookRunnerError> {
        let failureStrings: [String] = results.compactMap { result in
            var failureGroup: [String] = []
            if let regexErrorString = result.regex?.error?.description {
                failureGroup.append(regexErrorString.indented())
            }
            if let commandErrorString = result.command?.error?.description {
                failureGroup.append(commandErrorString.indented())
            }
            if !failureGroup.isEmpty {
                failureGroup.insert("\(result.hookName): \"\(result.message)\"", at: 0)
                return failureGroup.joined(separator: "\n")
            } else {
                return nil
            }
        }

        guard !failureStrings.isEmpty else { return .success(()) }
        let output = """
        The following failures occurred for the "\(gitHook)" git hook:

        \(failureStrings.joined(separator: "\n\n"))
        """
        return .failure(.hooksFailedEvaluation(output))
    }
}
