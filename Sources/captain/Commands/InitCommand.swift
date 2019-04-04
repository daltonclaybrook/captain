import Commandant
import Curry
import Result

struct InitCommand: CommandProtocol {
    let verb = "init"
    let function = "Creates a .captain.yml file"

    func run(_ options: InitOptions) -> Result<(), CommandantError<()>> {
        return .success(())
    }
}

struct InitOptions: OptionsProtocol {
    let path: String

    static func evaluate(_ mode: CommandMode) -> Result<InitOptions, CommandantError<CommandantError<()>>> {
        return curry(self.init)
            <*> mode <| Option(key: "path", defaultValue: ".", usage: "The path to the project directory")
    }
}
