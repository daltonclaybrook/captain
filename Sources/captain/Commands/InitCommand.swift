import CaptainKit
import Commandant
import Curry

struct InitCommand: CommandProtocol {
    let verb = "init"
    let function = "Create a .captain.yml file"

    func run(_ options: InitOptions) -> Result<(), CaptainError> {
        let absolutePath = options.path.bridge().absolutePathRepresentation()
        return Bootstrap()
            .createConfigFile(atPath: absolutePath)
            .mapCommandResult(onSuccess: { path in
                print("Config file successfully created at \(path)")
            })
    }
}

struct InitOptions: OptionsProtocol {
    let path: String

    static func evaluate(_ mode: CommandMode) -> Result<InitOptions, CommandantError<CaptainError>> {
        return curry(self.init)
            <*> mode <| Argument(defaultValue: ".", usage: "Path to the project directory", usageParameter: "path")
    }
}
