import Commandant
import Foundation

typealias ErrorStringType = Error & CustomStringConvertible
typealias CaptainError = CommandantError<ErrorStringType>

extension Result where Failure: ErrorStringType {
    func mapCommandResult(onSuccess: (Success) -> Void) -> Result<(), CaptainError> {
        return bimap(success: onSuccess, failure: CaptainError.commandError)
    }
}
