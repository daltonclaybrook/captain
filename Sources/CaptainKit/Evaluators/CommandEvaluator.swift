enum CommandEvaluatorError: Error {
    case commandFailed(String)
}

struct CommandEvaluator {
    let repoPath: String
    let command: String

    func evaluate() -> Result<(), CommandEvaluatorError> {
        let shell = Shell(directory: repoPath)
        let result = shell.run(command: command)
        if result.status != 0 {
            let errorString = result.standardError.trimmingCharacters(in: .whitespacesAndNewlines)
            return .failure(.commandFailed(errorString))
        }
        return .success(())
    }
}
