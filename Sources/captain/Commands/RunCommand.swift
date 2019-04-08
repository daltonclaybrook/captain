import CaptainKit
import Commandant
import Curry

struct RunCommand: CommandProtocol {
    let verb = "run"
    let function = "Called automatically when git invokes a hook"

    func run(_ options: RunOptions) -> Result<(), CaptainError> {
        return HookRunner(gitHook: options.gitHook)
            .run()
            .mapCommandResult()
    }
}

struct RunOptions: OptionsProtocol {
    let gitHook: String

    static func evaluate(_ mode: CommandMode) -> Result<RunOptions, CommandantError<CaptainError>> {
        return curry(self.init)
            <*> mode <| Argument(defaultValue: nil, usage: "The git hook", usageParameter: "hook")
    }
}
