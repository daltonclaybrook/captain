import CaptainKit
import Commandant
import Curry

struct RunCommand: CommandProtocol {
    let verb = "run"
    let function = "Called automatically when git invokes a hook"

    func run(_ options: RunOptions) -> Result<(), CaptainError> {
        return HookRunner(gitHook: options.gitHook, arguments: options.arguments)
            .run()
            .mapCommandResult()
    }
}

struct RunOptions: OptionsProtocol {
    let gitHook: String
    let arguments: String

    static func evaluate(_ mode: CommandMode) -> Result<RunOptions, CommandantError<CaptainError>> {
        return curry(self.init)
            <*> mode <| Argument(defaultValue: nil, usage: "The git hook", usageParameter: "hook")
            <*> mode <| Argument(defaultValue: "",
                                 usage: "Arguments passed to the hook by git", usageParameter: "args")
    }
}
