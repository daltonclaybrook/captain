import Commandant

typealias ErrorStringType = Error & CustomStringConvertible
typealias CaptainError = CommandantError<ErrorStringType>

extension Result where Failure: ErrorStringType {
    func mapCommandResult(onSuccess: (Success) -> Void = { _ in }) -> Result<(), CaptainError> {
        return map(onSuccess).mapError(CaptainError.commandError)
    }
}
