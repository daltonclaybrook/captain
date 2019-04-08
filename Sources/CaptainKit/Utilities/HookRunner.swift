import Foundation
import Yams
import os

public enum HookRunnerError: Error {
    case testError(String)
    case failedToParseConfig
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
        var regexResults: [String: Result<(), RegexEvaluatorError>] = [:]
        for (name, hook) in customHooks where hook.gitHook == gitHook {
            if let regex = hook.regex {
                let evaluator = RegexEvaluator(repoPath: fileManager.currentDirectoryPath, regex: regex)
                regexResults[name] = evaluator.evaluate()
            }
        }

        let testString = "hook: \(gitHook), args: \(String(describing: arguments))"
        return .failure(.testError(testString))
    }

    // MARK: - Helpers

    private func makeResult(from regexResults: [String: Result<(), RegexEvaluatorError>]) -> Result<(), HookRunnerError> {
        let failureStrings = regexResults.reduce(into: [String]()) { result, keyValue in
            let (hookName, regexResult) = keyValue
            if let error = regexResult.error {
                result.append(error.description)
            }
        }
        // TODO: fix me
        return .success(())
    }
}
