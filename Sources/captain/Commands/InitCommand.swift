import CaptainKit
import Commandant
import Curry
import Result

struct InitCommand: CommandProtocol {
    let verb = "init"
    let function = "Creates a .captain.yml file"

    func run(_ options: InitOptions) -> Result<(), CaptainError> {
        let fullPath = PathBuilder.fullPath(from: options.path)
        return Bootstrap()
            .createConfigFile(atPath: fullPath)
            .mapCommandResult(onSuccess: { path in
                print("Config file successfully created at \(path)")
            })
    }
}

struct InitOptions: OptionsProtocol {
    let path: String

    static func evaluate(_ mode: CommandMode) -> Result<InitOptions, CommandantError<CaptainError>> {
        return curry(self.init)
            <*> mode <| Option(key: "path", defaultValue: ".", usage: "The path to the project directory")
    }
}
