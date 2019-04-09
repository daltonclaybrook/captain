enum CommandEvaluatorError: Error {
}

struct CommandEvaluator {
    let command: String

    func evaluate() -> Result<(), CommandEvaluatorError> {
        // TODO: Implement
        return .success(())
    }
}
